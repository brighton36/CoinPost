require 'spec_helper'

describe Purchase do
  context "defaults on new" do
    before {
      @item = create :item 
      @purchase = Purchase.create :item => @item, 
        :purchaser => FactoryGirl.singleton_user(:user_ricon)
    }
    after { @item.destroy; @purchase.destroy }
    subject{@purchase}

    its(:btc_receive_address){ should eq('37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare') }
    its(:price){ should eq(8) }
    its(:quantity_purchased){ should eq(1) }
    its(:total){ should eq(8) }

    its(:rating_on_purchaser){ should eq(0) }
    its(:rating_on_seller){ should eq(0) }

    its(:comment_on_purchaser){ should be_nil }
    its(:comment_on_seller){ should be_nil }
    its(:fulfillment_notes){ should be_nil }

    its(:payment_sent_at){ should be_nil }
    its(:item_sent_at){ should be_nil }
  end

  context "total price calculation" do
    before {
      @item = create :item 
      @purchase = Purchase.create :item => @item, 
        :purchaser => FactoryGirl.singleton_user(:user_ricon),
        :quantity_purchased => 2
    }
    after { @item.destroy; @purchase.destroy }
    subject{@purchase}
    
    its(:total){should eq(16)}
    its(:total_in_cents){should eq(1600000000)}
  end

  context "total price calculation from USD priced item" do
    before {
      MtgoxBank.ticker_rates = {'usd' => 2.0}

      @item = create :item, :price => Money.new(100, 'USD')
      @purchase = Purchase.create :item => @item, 
        :purchaser => FactoryGirl.singleton_user(:user_ricon),
        :quantity_purchased => 2
    }
    after { MtgoxBank.ticker_rates = nil; @item.destroy; @purchase.destroy }
    subject{@purchase}
    
    its(:total){should eq(1)}
    its(:total_in_cents){should eq(100000000)}
  end

  describe "validations" do
    before do 
      @item = create :item, :lists_at => Time.now.utc-900, :quantity_listed => 5
      @user = FactoryGirl.singleton_user :user_ricon
      @purchase = Purchase.create :item => @item, :purchaser => @user, 
        :quantity_purchased => 1
    end
    after { Item.destroy_all; Purchase.destroy_all }
  
    # Base validation
    it 'should be valid with item and purchaser' do
      Purchase.new(:item => @item, :purchaser => @user, 
        :quantity_purchased => 1).should be_valid
    end

    # Validates presence:
    it 'shouldnt be valid without item' do
      Purchase.new(:purchaser => @user, :quantity_purchased => 1).should_not be_valid
    end

    it 'shouldnt be valid without purchaser' do
      Purchase.new(:item => @item, :quantity_purchased => 1).should_not be_valid
    end

    it 'shouldnt be valid without quantity' do
      purchase = Purchase.new :item => @item, :purchaser => @user

      purchase.quantity_purchased = nil
      purchase.should_not be_valid
    end

    # Validates unchangeable
    it 'shouldnt be able to change item' do
      @purchase.item = create :item, :title => 'New Item'
      @purchase.should_not be_valid
    end

    it 'shouldnt be able to change user' do
      @purchase.purchaser = FactoryGirl.singleton_user :user_stewie
      @purchase.should_not be_valid
    end
    
    it 'shouldnt be able to change quantity' do
      @purchase.quantity_purchased = 2
      @purchase.should_not be_valid
    end

    it 'shouldnt be able to change price' do
      @purchase.price = 2
      @purchase.should_not be_valid
    end

    # Validates format
    it 'should validate the purchaser comments format' do
      @purchase.comment_on_purchaser = '`Invalid`'
      @purchase.should_not be_valid
    end
    
    it 'should validate the seller comments format' do
      @purchase.comment_on_seller = '`Invalid`'
      @purchase.should_not be_valid
    end
    
    it 'should validate the purchaser comments format' do
      @purchase.fulfillment_notes = '`Invalid`'
      @purchase.should_not be_valid
    end

    # Validates quantity > 0
    it 'should validate the purchaser comments format' do
      Purchase.new(:item => @item, :purchaser => @user, 
        :quantity_purchased => 0).should_not be_valid
    end

    # Validates item is purchaseable:
    it 'should not be able to create from an expired listing' do
      expired_item = FactoryGirl.create_sixty_days_ago_item

      Purchase.new(:item => expired_item, :purchaser => @user, 
        :quantity_purchased => 1).should_not be_valid
    end

    it 'should not be able to create from an pending listing' do
      future_item = create :twenty_days_in_future_item

      Purchase.new(:item => future_item, :purchaser => @user, 
        :quantity_purchased => 1).should_not be_valid
    end

    it 'should not be able to create from a disabled listing' do
      disabled_item = create :item, :enabled => false
      Purchase.new(:item => disabled_item, :purchaser => @user, 
        :quantity_purchased => 1).should_not be_valid
    end

    it 'should not be able to create from a listing without quantity' do
      no_quantity_item = create :item, :quantity_listed => 1
      no_quantity_item.purchases.create :purchaser => @user, :quantity_purchased => 1

      Purchase.new(:item => no_quantity_item, :purchaser => @user, 
        :quantity_purchased => 1).should_not be_valid
    end
  end

  describe "scopes" do
    before do
      @ricon = FactoryGirl.singleton_user :user_ricon
      @stewie = FactoryGirl.singleton_user :user_stewie
 
      @purchases = {} 
      %w(stewies ricons).each do |u| 
        %w( 
        purchase purchase_payment_sent purchase_item_sent purchase_item_sent_no_payment 
        ).each{|p| 
          key = [u,p].join('_').to_sym
          
          @purchases[key] = create key
        }
      end
    end

    after do
      Item.destroy_all
      Purchase.destroy_all
    end

    def purchase_ids_for(expects)
      expects.collect{ |key| @purchases[key.to_sym].id }
    end

    it "should query items I've sold and not fulfilled" do
      Purchase.created_by(@ricon).unfulfilled.collect(&:id).should eq(
        purchase_ids_for %w(stewies_purchase_payment_sent stewies_purchase) )
    end

    it "should query items I've fulfilled" do
      Purchase.created_by(@ricon).fulfilled.collect(&:id).should eq(
        purchase_ids_for %w(stewies_purchase_item_sent_no_payment stewies_purchase_item_sent) )
    end

    it "should query items I've not paid for" do
      Purchase.purchased_by(@ricon).unpaid.collect(&:id).should eq(
        purchase_ids_for %w(ricons_purchase) )
    end

    it "should query items I've paid for" do
      Purchase.purchased_by(@ricon).paid.collect(&:id).should eq(
        purchase_ids_for %w(ricons_purchase_item_sent_no_payment ricons_purchase_item_sent ricons_purchase_payment_sent ) )
    end

    describe "Ratings Scopes" do
      before do
        # This should have no effect on whether we're returned:
        @purchases[:ricons_purchase_item_sent].tap do |p|
          p.rating_on_purchaser = 1
          p.comment_on_purchaser = "Good dude"
          p.save!
        end

        # This should prevent us from being returned:
        @purchases[:ricons_purchase_item_sent_no_payment].tap do |p|
          p.rating_on_seller = -1
          p.save!
        end

        # This should have no effect on whether we're returned:
        @purchases[:stewies_purchase_item_sent].tap do |p|
          p.rating_on_seller = -1
          p.comment_on_seller = "Bad dude"
          p.save!
        end

        # This should prevent us from being returned:
        @purchases[:stewies_purchase_item_sent_no_payment].tap do |p|
          p.rating_on_purchaser = 1
          p.save!
        end
      end
      
      it "should query purchases I need to leave feedback on" do
        Purchase.needs_feedback_from_purchaser(@ricon).collect(&:id).should eq(
          purchase_ids_for %w(ricons_purchase_item_sent ricons_purchase_payment_sent ricons_purchase) )
      end
      
      it "should query sales I need to leave feedback on" do
        Purchase.needs_feedback_from_seller(@ricon).collect(&:id).should eq(
          purchase_ids_for %w(stewies_purchase_item_sent stewies_purchase_payment_sent stewies_purchase) )
      end

      it "should display purchases and sales that I need to leave feedback on" do
        Purchase.completed_needing_feedback_from(@ricon).collect(&:id).should eq(
          purchase_ids_for( %w(ricons_purchase_item_sent ricons_purchase_payment_sent  
          stewies_purchase_item_sent ) ) )
      end

      it "should display purchases and sales that received feedback on" do
        Purchase.with_feedback_for(@ricon).collect(&:id).should eq(
          purchase_ids_for( %w(ricons_purchase_item_sent  stewies_purchase_item_sent ) ) )
      end

      it "should query completed purchases with feedback for the seller" do
        Purchase.has_feedback_as_seller(@ricon).collect(&:id).should eq(
          purchase_ids_for( %w(stewies_purchase_item_sent ) ) )
      end

      it "should query completed purchases with feedback for the purchaser" do
        Purchase.has_feedback_as_purchaser(@ricon).collect(&:id).should eq(
          purchase_ids_for( %w(ricons_purchase_item_sent) ) )
      end
    end
  end

end

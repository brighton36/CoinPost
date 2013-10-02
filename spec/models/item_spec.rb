require 'spec_helper'

describe Item do

  def quantity_purchased(item, quantity)
    @user_ricon ||= FactoryGirl.singleton_user :user_ricon
    item.purchases.create! :purchaser => @user_ricon, :quantity_purchased => quantity
  end

  describe "defaults" do
    context "on new" do
      before(:all) {@item = Item.new }

      its(:quantity_listed){should eq(1)}
      its(:title){should be_nil}
      its(:btc_receive_address){should be_nil}

      its(:creator){should be_nil}
      its(:shipping_policy){should be_nil}
      its(:return_policy){should be_nil}
      its(:location){should be_nil}
      its(:slug){should be_nil}
      its(:description){should be_nil}
      its(:price){should eq(0)}

      its(:lists_at){should be_kind_of(Time)}
      its(:expires_at){should be_kind_of(Time)}
      
      it "should have a btc price by default" do 
        @item.price.currency_as_string.should eq('BTC')
      end
    end
  end

  describe "attributes" do

    it "should calculate the quantity_available" do
      item = create :item, :quantity_listed => 34
      quantity_purchased item, 14

      item.quantity_available.should eq(20)  
    end
    
    it "should calculate the quantity_available after purchase removal" do
      # This shouldn't ever happen in production, but I wrote the code for this
      # in the model, and thus, it should go tested:

      item = create :item, :quantity_listed => 34
      purchase = item.purchases.create :quantity_purchased => 14, 
        :purchaser => FactoryGirl.singleton_user(:user_ricon)

      purchase.destroy

      item.quantity_available.should eq(34)  
    end

    it "should identify if the item has sales" do
      item_a = create :item, :quantity_listed => 34
      item_b = create :item, :quantity_listed => 34
      quantity_purchased item_a, 14

      item_a.has_sales.should be_true
      item_b.has_sales.should be_false
    end

    it "should indicate expiration status" do
      item = FactoryGirl.create_sixty_days_ago_item
      
      item.is_expired.should be_true
    end
    
    it "should indicate pending status" do
      item_a = create :twenty_days_in_future_item
      item_b = create :item, :title => 'Valid Product', :lists_at => Time.now.utc

      item_a.is_pending.should be_true
      item_b.is_pending.should be_false
    end
  end

  describe "price" do
    it "should reflect 10000000.00000001 price" do
      item = build :item, :price => "10000000.00000001"

      item.should be_valid
      item.price_in_cents.should eq(1000000000000001)
    end

    it "should reflect 99999999.99999999 price" do
      item = create :item, :price => "9999999999999999"
      item.should be_valid
      item.price_in_cents.should eq(999999999999999900000000)
    end
  end

  describe "time storage" do
    before do
      @zone_before = Time.zone
      Time.zone = ActiveSupport::TimeZone["America/Los_Angeles"]
    end
    after{ Time.zone = @zone_before}

    it 'should store dates as utc' do
      Delorean.time_travel_to(Time.zone.parse('2011-01-04 2pm')) do
        now_in_tz = Time.zone.now
        lists_at_create = now_in_tz
        expires_at_create = now_in_tz + 3600*72

        item = create :item, 
          :lists_at => lists_at_create, :expires_at => expires_at_create

        Time.zone = ActiveSupport::TimeZone["Etc/Utc"]

        item = Item.find(item.id)

        item.lists_at.zone.should eq('UTC')
        item.expires_at.zone.should eq('UTC')
    
        item.lists_at.hour.should eq(now_in_tz.hour+8)
        item.lists_at.min.should eq(now_in_tz.min)
      end
    end
  end

  describe "time setters" do
    [
    [ '00:00 AM', 0, 0 ], [ '01:02 PM', 13, 02 ], [ '1:2 AM', 1, 2 ],
    [ '4:05 p', 16, 5], ['4 a',4,0],
    [ '1:20 AM', 1, 20 ], [ '14:00', 14, 0], [ '14:0', 14, 0], [ '15', 15, 0],
    [ '13:04 PM', 13, 04 ]
    ].each do |setter|
      it( 'should accept %s' % setter[0] ) do
        item = build(:item, :expires_at_time => setter[0] )
        item.expires_at_time.should eq(setter[0])
        [:hour,:min].collect{|a| 
          item.expires_at.send(a)
        }.should eq setter[1..2]
      end
    end
  end
  
  describe "date setters" do
    [
    [ '1/2/03', 1, 2, 2003 ], [ '02/03/2004', 2, 3, 2004 ],
    [ '03/4/5', 3, 4, 2005 ], [ '01/02', 1, 2,Time.new.utc.year ],
    [ '01', 1, 1, Time.new.utc.year ]
    ].each do |setter|
      it( 'should accept %s' % setter[0]) do
        item = build(:item, :expires_at_date => setter[0] )
        item.expires_at_date.should eq(setter[0])
        [:month,:day,:year].collect{|a| 
          item.expires_at.send(a)
        }.should eq setter[1..3]
      end
    end
  end

  describe "time and date setter" do
    it 'should not screw up on time then date set' do
      item = build :item
      item.expires_at_time= '01:02 PM'
      item.expires_at_date= '12/01/2012'
      [:month,:day,:year, :hour,:min].collect{|a| 
        item.expires_at.send(a)
      }.should eq([12,1,2012,13,2])
    end

    it 'should not screw up on date then time set' do
      item = build :item
      item.expires_at_date= '12/01/2012'
      item.expires_at_time= '01:02 PM'
      [:month,:day,:year, :hour,:min].collect{|a| 
        item.expires_at.send(a)
      }.should eq([12,1,2012,13,2])
    end
  end 

  describe "validations" do
    after{ Item.delete_all; Category.delete_all }

    # Base validation
    it 'should be valid on default build' do
      build(:item).should be_valid
    end
    
    it 'validates title presense' do
      build(:item, :title => nil).should_not be_valid
    end
    
    # Date validations:
    it 'validates lists_at dates are within 31 days of now' do
      build(:item, :lists_at => 32.days.from_now).should_not be_valid
    end

    it 'validates expires_at dates are within 31 days of lists_at' do
      build( :item, 
        :lists_at => 2.days.from_now, :expires_at => 34.days.from_now
      ).should_not be_valid
    end

    # Category Validations
    it 'validates categories exist' do
      build(:item, :categories => []).should_not be_valid
    end

    it 'validates 3 categories are its max' do
      categories = [:electronics_category, :entertainment_category, 
        :collectibles_category,:decorations_category ].collect{|c|
        FactoryGirl.singleton_category(c)
      }
      build(:item, :categories => categories).should_not be_valid
    end
    
    it 'validates the quantity_purchased does not exceed the quantity_listed' do
      item = create :item, :quantity_listed => 4 
      
      Purchase.new(:item => item, :quantity_purchased => 5,
        :purchaser => FactoryGirl.singleton_user(:user_ricon)).should_not be_valid
    end

    # Owner Validations
    it 'validates the creator exists' do
      build(:item, :creator => nil).should_not be_valid
    end

    # Readonly validations
    it 'should not allow the lists_at to change' do
      item = create(:item)
      item.should be_valid

      item.lists_at = 2.days.from_now
      item.should_not be_valid
    end

    it 'should not allow the expires_at to change' do
      item = create(:item)
      item.should be_valid

      item.expires_at = 28.days.from_now
      item.should_not be_valid
    end
    
    it 'should not allow the creator to change' do
      new_user = create :user, 
        :name => 'ChangedCreator', :email => 'aou@aoeu.com'

      item = create(:item)
      item.should be_valid

      item.creator = new_user 
      item.should_not be_valid
    end

    it 'should accept up to six images' do
      user = create :user
      item = build(
        :item,
        :creator => user,
        :images => (1..6).collect{build :item_image, :creator => user}
      )
      
      item.should be_valid
    end
    
    it 'should not accept seven images' do
      user = create :user
      item = build(
        :item,
        :creator => user,
        :images => (1..7).collect{build :item_image, :creator => user}
      )

      item.should_not be_valid
    end
  end

  describe "sanitization" do
    it "should sanitize its description" do
      item = build :item, 
        :description => 'Hello <script>alert("stripme");</script> World'

      item.description.should eq('Hello  World')
    end

    it "should allow recognized style tag content" do
      description_before = "<p style=\"text-align:left; padding-left: 30px; height: 40px;\">This is a good p \n<span style=\"color:#339966\">With</span><span style=\"text-decoration: underline;\n width : 40px\">a good span</span></p>"
      description_after = "<p style=\"text-align:left;padding-left:30px;height:40px\">This is a good p \n<span style=\"color:#339966\">With</span><span style=\"text-decoration:underline;width:40px\">a good span</span></p>"

      item = build :item, :description => description_before

      item.description.should eq(description_after)
    end

    it "should not allow unknown styles" do
      description_before = "<p style=\"text-align\n : left; border: 1px\">Test</p>"
      description_after  = "<p style=\"text-align:left\">Test</p>"

      item = build :item, :description => description_before

      item.description.should eq(description_after)
    end

    it "should remove empty style tags" do
      description_before = "<span style=\"font-weight: bold\">Test</p>"
      description_after  = "<span>Test</span>"

      item = build :item, :description => description_before

      item.description.should eq(description_after)
    end

    it "should not inadvertantly whitelist bad tags with good style" do
      description_before = "<button style=\"text-align: left\">Bad Tag</button>"

      item = build :item, :description => description_before

      item.description.should be_empty
    end
  end

  describe "scopes" do
    before do
      @now = Time.now.utc 
      @ricon = FactoryGirl.singleton_user(:user_ricon)

      # Create expired product
      FactoryGirl.create_sixty_days_ago_item
      FactoryGirl.create_sixty_days_ago_item :creator => @ricon, 
        :title => 'Ricon item'

      # Create product that has yet to list:
      create :twenty_days_in_future_item
    end

    after { Item.delete_all; Category.delete_all }

    it "should query purchaseaable items" do
      # These products are the only one that are 'purchaseable'
      create :item, :title => 'Youngest', :lists_at => @now-900 
      create :item, :title => 'Midlest', :lists_at => @now-1800
      create :item, :title => 'Oldest', :lists_at => @now-3500 
     
      Item.purchaseable.order('items.expires_at ASC').collect(&:title).should eq(%w(Oldest Midlest Youngest)) 
    end

    it "should query purchaseable items in categories" do
      categories = FactoryGirl.create_category_tree
      
      create :item, :title => 'Item D', :lists_at => @now-3300,
        :categories => [categories[:tools_category] ]
      create :item, :title => 'Item C', :lists_at => @now-3300,
        :categories => [categories[:decorations_category] ]
      create :item, :title => 'Item B', :lists_at => @now-3400,
        :categories => [categories[:video_category] ]

      # This is the only one that should match:
      create :item, :title => 'Item A', :lists_at => @now-3500, 
        :categories => [categories[:electronics_category] ]
      
      Item.purchaseable_in_categories(
        categories[:electronics_category]
      ).collect(&:title).should eq(%w(Item\ A)) 
    end
    
    it "should not include disabled items in purchaseable" do
      item_a = create :disabled_item
      item_b = create :enabled_item

      Item.purchaseable.collect(&:title).should eq(%w(Enabled)) 
      item_a.is_purchaseable.should be_false
      item_b.is_purchaseable.should be_true
    end
    
    it "should not include quantity unavailable in purchaseable" do
      item_a = create :item, :title => 'Quantity Reached', :lists_at => @now-900,
        :quantity_listed => 4
      quantity_purchased item_a, 4

      item_b = create :item, :title => 'Near Quantity', :lists_at => @now-300,
        :quantity_listed => 4
      quantity_purchased item_b, 3

      Item.purchaseable.collect(&:title).should eq(['Near Quantity']) 
      item_a.is_purchaseable.should be_false
      item_b.is_purchaseable.should be_true
    end

    it "should query unpurchaseable items" do
      item_a = create :item, :title => 'Valid Product', :lists_at => @now-900 

      item_b = create :item, :title => 'Quantity Reached', :lists_at => @now-900,
        :quantity_listed => 4
      quantity_purchased item_b, 4

      item_c = create :item, :title => 'Near Quantity', :lists_at => @now-300,
        :quantity_listed => 4
      quantity_purchased item_c, 3
      
      item_d = create :disabled_item
      item_e = create :enabled_item

      Item.unpurchaseable.order('expires_at ASC').collect(&:title).should eq(
        ['Sixty days ago', 'Ricon item', 'Quantity Reached', 'Disabled',  
         'Twenty days from now']
      )
      item_a.is_unpurchaseable.should be_false
      item_b.is_unpurchaseable.should be_true
      item_c.is_unpurchaseable.should be_false
      item_d.is_unpurchaseable.should be_true
      item_e.is_unpurchaseable.should be_false
    end

    it "should query expired items" do
      Item.expired.collect(&:title).should eq(['Sixty days ago','Ricon item'])
    end
    
    it "should query pending items" do
      Item.pending.collect(&:title).should eq(['Twenty days from now'])
    end

    it "should query not_pending items" do
      create :item, :title => 'Valid Product', :lists_at => @now-900 

      Item.not_pending.collect(&:title).should eq(
        ['Sixty days ago', 'Ricon item', 'Valid Product'] )
    end

    it "should query items created by a user" do
      Item.created_by(@ricon).collect(&:title).should eq(['Ricon item'])
    end
    
    it "should query pending items" do
      create :item, :title => 'Youngest', :lists_at => @now-900 
      Item.current_or_pending.collect(&:title).should eq(['Youngest','Twenty days from now'])
    end
  end

  describe "purchase tracking" do
    before do
      @user_ricon = FactoryGirl.singleton_user :user_ricon
      @user_luwin = FactoryGirl.singleton_user :user_luwin
      @user_jory = FactoryGirl.singleton_user :user_jory
    end
    after { Item.delete_all; Category.delete_all }

    it "should track the inventory available" do
      item = create :item, :quantity_listed => 8
      item.purchases.create :purchaser => @user_ricon, :quantity_purchased => 2
      item.purchases.create :purchaser => @user_luwin, :quantity_purchased => 3
      item.purchases.create :purchaser => @user_jory, :quantity_purchased => 1


      item.quantity_purchased.should eq(6)
      item.quantity_available.should eq(2)
    end
    
    it "should be unpurchaseable if the inventory is gone" do
      item = create :item, :quantity_listed => 2
      item.purchases.create :purchaser => @user_ricon, :quantity_purchased => 1
      item.purchases.create :purchaser => @user_luwin, :quantity_purchased => 1

      item.is_purchaseable.should be_false
    end

    it "shouldnt appear in purchaseable scope if the inventory is gone" do
      item = create :item, :quantity_listed => 1
      item.purchases.create :purchaser => @user_ricon, :quantity_purchased => 1
      
      Item.purchaseable.should eq([])
    end
  end

  describe "price currency & conversion support" do
    context "simple conversion rate" do 
      before{ MtgoxBank.ticker_rates = {'usd' => 2.0 } }
      after{ MtgoxBank.ticker_rates = nil }

      # This probably doesn't belong here, but its a small class
      it "should use MtgoxBank to convert dollars to btc" do
        Money.new(100, 'USD').exchange_to('BTC').cents.should eq(50000000)
      end 

      # This probably doesn't belong here, but its a small class
      it "should use MtgoxBank to convert btc to dollars" do
        Money.new(100000000, 'BTC').exchange_to('USD').cents.should eq(200)
      end 

      it "should support storing an iso currency with the price" do
        create :item, :title => 'Currency Test', :price => Money.new(100, 'USD')
        
        Item.where(:title => 'Currency Test').first.price.currency_as_string.should eq('USD')
      end

      it "should support converting the price currency" do
        create :item, :title => 'Currency Test', :price => Money.new(100, 'USD')
        
        Item.where(:title => 'Currency Test').first.price.exchange_to('BTC').cents.should eq(50000000)
      end

      it "should support the price_in_btc setter" do
        create :item, :title => 'Currency Test', :price_in_btc => '1'
        
        Item.where(:title => 'Currency Test').first.price.cents.should eq(100000000)
      end

      it "should support the price_in_usd setter" do
        create :item, :title => 'Currency Test', :price_in_currency => { 
          :currency => 'USD', :price => '2'}
        
        Item.where(:title => 'Currency Test').first.price.exchange_to('BTC').cents.should eq(100000000)
      end
    end

    context "irrational number conversions" do
      after{ MtgoxBank.ticker_rates = nil }

      it "should round to 0 fractional digits on 4 fractional digit rate" do
        MtgoxBank.ticker_rates = {'usd' => 0.00023333333}
        @item = create :currency_test_item
        
        @item.price.exchange_to('BTC').to_s.should eq("4285.00000000")
      end

      it "should round to 0 fractional digits on 3 fractional digit rate" do
        MtgoxBank.ticker_rates = {'usd' => 0.0023333333}
        @item = create :currency_test_item
        
        @item.price.exchange_to('BTC').to_s.should eq("428.00000000")
      end

      it "should round to 1 fractional digits on 2 fractional digit rate" do
        MtgoxBank.ticker_rates = {'usd' => 0.023333333}
        @item = create :currency_test_item

        @item.price.exchange_to('BTC').to_s.should eq("42.80000000")
      end
      
      it "should round to 2 fractional digits on 1 fractional digit rate" do
        MtgoxBank.ticker_rates = {'usd' => 0.23333333}

        @item = create :currency_test_item
        
        @item.price.exchange_to('BTC').to_s.should eq("4.28000000")
      end

      it "should round to 3 fractional digits on 1 decimal digit rate" do
        MtgoxBank.ticker_rates = {'usd' => 2.33333333}

        @item = create :currency_test_item
        
        @item.price.exchange_to('BTC').to_s.should eq("0.42800000")
      end

      it "should round to 4 fractional digits on 2 decimal digit rate" do
        MtgoxBank.ticker_rates = {'usd' => 22.33333333}

        @item = create :currency_test_item
        
        @item.price.exchange_to('BTC').to_s.should eq("0.04470000")
      end

      it "should round to 5 fractional digits on 3 decimal digit rate" do
        MtgoxBank.ticker_rates = {'usd' => 222.33333333}

        @item = create :currency_test_item
        
        @item.price.exchange_to('BTC').to_s.should eq("0.00449000")
      end
      
    end
    
    context "Cross currency conversions" do 
      before{ MtgoxBank.ticker_rates = {'usd' => 5, 'eur' => 10 } }
      after{ MtgoxBank.ticker_rates = nil }

      # This probably doesn't belong here, but it's a small class
      it "should convert from us dollars to thai bahts" do
        Money.new(100, 'USD').exchange_to('EUR').cents.should eq(200)
      end 
    end
  end

  describe "Slug Tests" do
    context "Item is relisted by same user - url's shift" do
      before(:all) do
        # Keep in mind that these expire in a week, and are created by stewie:
        Delorean.time_travel_to(Time.zone.parse('2013-01-01 12pm')) do
          @item_first = create :item, :title => 'Gold Duhbloons' 
        end

        # What follows is very similar to what happens in ItemController#relist
        Delorean.time_travel_to(Time.zone.parse('2013-01-09 12pm')) do
          first_categories = @item_first.categories

          @item_relist1 = @item_first.dup
          @item_relist1.set_default_values(true)
          @item_relist1.expires_at = @item_relist1.lists_at + 1.week
          @item_relist1.categories = first_categories
          @item_relist1.save!
        end

        Delorean.time_travel_to(Time.zone.parse('2013-01-18 12pm')) do
          relist_categories = @item_relist1.categories

          @item_relist2 = @item_relist1.dup
          @item_relist2.set_default_values(true)
          @item_relist2.expires_at = @item_relist2.lists_at + 1.week
          @item_relist2.categories = relist_categories
          @item_relist2.save!
        end

        @item_first.reload
        @item_relist1.reload
        @item_relist2.reload
      end

      after(:all){ Item.delete_all; Category.delete_all }

      it "should have changed the initial item url to stewie-griffen/gold-duhbloons--2 " do
        @item_first.to_param.should eq('stewie-griffen/gold-duhbloons--2')
      end

      it "should have set the first relist of the item url to a stewie-griffen/gold-duhbloons--3" do
        @item_relist1.to_param.should eq('stewie-griffen/gold-duhbloons--3')
      end

      it "should have set the most recent relist's url to a stewie-griffen/gold-duhbloons" do
        @item_relist2.to_param.should eq('stewie-griffen/gold-duhbloons')
      end
    end

    context "Item with identical title slug is posted by different user, and relisted" do
      before do
        @ricon = FactoryGirl.singleton_user :user_ricon
        @jory = FactoryGirl.singleton_user :user_jory

        # Keep in mind that these expire in a week, and are created by stewie:
        Delorean.time_travel_to(Time.zone.parse('2013-01-01 12pm')) do
          @ricon_item = create :item, :title => 'Elven Dagger', :creator => @ricon
        end

        # What follows is very similar to what happens in ItemController#relist
        Delorean.time_travel_to(Time.zone.parse('2013-01-08 12pm')) do
          @jory_item = create :item, :title => 'Elven Dagger', :creator => @jory
        end

        Delorean.time_travel_to(Time.zone.parse('2013-01-16 12pm')) do
          jory_item_categories = @jory_item.categories

          @jory_relist = @jory_item.dup
          @jory_relist.set_default_values(true)
          @jory_relist.expires_at = @jory_relist.lists_at + 1.week
          @jory_relist.categories = jory_item_categories
          @jory_relist.save!
        end

        @ricon_item.reload
        @jory_item.reload
        @jory_relist.reload
      end
      after(:all){ Item.delete_all; Category.delete_all }

      it "should have kept the initial item url to ricon/elven-dagger" do
        @ricon_item.to_param.should eq('rickon-stark/elven-dagger')
      end

      it "should have set the jory item url to a jory/elven-dagger--2" do
        @jory_item.to_param.should eq('jory-cassel/elven-dagger--2')
      end

      it "should have set the jory relist url to a jory/elven-dagger" do
        @jory_relist.to_param.should eq('jory-cassel/elven-dagger')
      end
    end
    
    context "Item with active status doesn't change its url" do
      before(:all) do
        # Keep in mind that these expire in a week, and are created by stewie:
        Delorean.time_travel_to(Time.zone.parse('2013-01-01 12pm')) do
          @item_first = create :item, :title => 'Jogging Shorts' 
        end

        Delorean.time_travel_to(Time.zone.parse('2013-01-03 12pm')) do
          @item_second = create :item, :title => 'Jogging Shorts' 
        end

        @item_first.reload
        @item_second.reload
      end

      after(:all) { Item.delete_all; Category.delete_all }


      it "should have set the first active item url to a stewie-griffen/jogging-shorts" do
        @item_first.to_param.should eq('stewie-griffen/jogging-shorts')
      end

      it "should have set the second active item url to a stewie-griffen/jogging-shorts--2" do
        @item_second.to_param.should eq('stewie-griffen/jogging-shorts--2')
      end
    end

  end

  describe "to_csv" do
    it "should return an array of columns with the item attributes" do
      item = nil
      Delorean.time_travel_to(Time.zone.parse('2013-01-03 12pm')) do
        item = FactoryGirl.create(:item)
      end
      item.to_csv.should eq(["Chia Pet", "New York, NY", 5, 800000000, "BTC", "37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare", "2013-01-03T12:00:00Z", "2013-01-10T12:00:00Z", "electronics,home-decorations", "This lovable pet <strong> only requires <strong>Sunshine and water</strong></strong>", nil, nil, nil, nil, nil, nil, nil, nil])
    end

    it "should return an array of columns with the item attributes and policies" do
      item = nil
      Delorean.time_travel_to(Time.zone.parse('2013-01-03 12pm')) do
        shipping_policy = FactoryGirl.create(:sp_after_sale)
        return_policy = FactoryGirl.create(:rp_replacements)
        item = FactoryGirl.create :item, :shipping_policy => shipping_policy, 
          :return_policy => return_policy
      end
      item.to_csv.should eq(["Chia Pet", "New York, NY", 5, 800000000, "BTC", "37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare", "2013-01-03T12:00:00Z", "2013-01-10T12:00:00Z", "electronics,home-decorations", "This lovable pet <strong> only requires <strong>Sunshine and water</strong></strong>", "Replacements Only", "Calculated after sale", nil, nil, nil, nil, nil, nil])
    end

    it "should include image urls for items which include images" do
      item = nil
      Delorean.time_travel_to(Time.zone.parse('2013-01-03 12pm')) do
        item = FactoryGirl.build(:item)

        # Attach some images:
        item.images = %w(coach-bag1 coach-bag2 coach-bag3 coach-bag4 generator 
          iphone).collect do |img| 
          img_path = ['db', 'seed-images', '%s.jpg' % img]
          image = ItemImage.new :image => File.new( Rails.root.join(*img_path) )
          image.creator = item.creator
          image
        end

        item.save!
      end

      item.to_csv.should eq(["Chia Pet", "New York, NY", 5, 800000000, "BTC", "37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare", "2013-01-03T12:00:00Z", "2013-01-10T12:00:00Z", "electronics,home-decorations", "This lovable pet <strong> only requires <strong>Sunshine and water</strong></strong>", nil, nil, item.images[0].image.url, item.images[1].image.url, item.images[2].image.url,item.images[3].image.url,item.images[4].image.url,item.images[5].image.url])
    end

  end
end

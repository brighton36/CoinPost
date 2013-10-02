require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject invalid btc addresses" do
    invalid_btc_user = User.new(@attr.merge(:btc_receive_address => 'beefcakes'))
    invalid_btc_user.should_not be_valid
  end

  it "should accept valid btc addresses" do
    valid_btc_user = User.new(@attr.merge(:btc_receive_address => '37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare'))
    valid_btc_user.should be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
  end
 
  describe "name unchangeable validation" do
    before(:each){ @user = User.create(@attr) }
    after(:each){ @user.destroy }
  
    it "should not be able to change its name" do
      @user.name = "Invalid"
      @user.should_not be_valid
    end
  end

  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  # There's probably a better place for this, but I put it here nontheless
  describe "unread message counters" do
    before(:each) do
      @stewie = FactoryGirl.singleton_user :user_stewie
      @ricon  = FactoryGirl.singleton_user :user_ricon
     
      %w(One Two Three Four).each do |i|
        @ricon.send_message @stewie, 
          'Seed Message for testing.', 'Message To Stewie %s' % i
      end
    end

    it "should match the full inbox unread count" do
      @stewie.messages_in_inbox.unread.count.should eq(4)
    end
    
    it "should represent a partially read inbox" do
      @stewie.read @stewie.messages_in_inbox.last

      @stewie.messages_in_inbox.unread.count.should eq(3)
    end
    
    it "should represent a partially read inbox part two" do
      @stewie.read @stewie.messages_in_inbox.first

      @stewie.messages_in_inbox.unread.count.should eq(3)
    end
    
    it "should represent an entirely read inbox" do
      @stewie.messages_in_inbox.each{ |msg| @stewie.read msg }

      @stewie.messages_in_inbox.unread.count.should eq(0)
    end
  end

  describe "message finders" do
    before(:each) do
      @stewie = FactoryGirl.singleton_user :user_stewie
      @ricon  = FactoryGirl.singleton_user :user_ricon
     
      %w(One Two Three Four).each do |i|
        @stewie.send_message @ricon, 
          'Seed Message for testing.', 'Message To Ricon %s' % i
        @ricon.send_message @stewie, 
          'Seed Message for testing.', 'Message To Stewie %s' % i
      end

      @stewie.mailbox.inbox.each do |conv| 
        case conv.subject
          when 'Message To Stewie Two'
            @stewie.reply_to_conversation conv, 'Reply Body', 'RE: Message To Stewie Two'
          when 'Message To Stewie Three'
            @stewie.trash conv
          when 'Message To Stewie Four'
            @stewie.reply_to_conversation conv, 'Reply Body', 'RE: Message To Stewie Four'
        end
      end

      @ricon.mailbox.inbox.each do |conv| 
        case conv.subject
          when 'Message To Ricon Two'
            @ricon.reply_to_conversation conv, 'Reply Body', 'RE: Message To Ricon Two'
          when 'Message To Ricon Three'
            @ricon.trash conv
          when 'Message To Ricon Four'
            @ricon.reply_to_conversation conv, 'Reply Body', 'RE: Message To Ricon Four'
        end
      end

      # Trash a reply, just to see if this makes any difference...
      @ricon.trash @ricon.mailbox.inbox.find{|conv| 
        conv.subject == 'Message To Stewie Four' }.messages.find{|msg|
        msg.subject == 'RE: Message To Stewie Four' }

      @stewie.trash @stewie.mailbox.inbox.find{|conv| 
        conv.subject == 'Message To Ricon Four' }.messages.find{|msg|
        msg.subject == 'RE: Message To Ricon Four' }
    end

    it "should match the mailboxer inbox conversation messages to the inbox" do
      @stewie.messages_in_inbox.collect(&:subject).should eq(
        [ "RE: Message To Ricon Two", "Message To Stewie Four", 
          "Message To Stewie Two", "Message To Stewie One"] )
    end

    it "should match the mailboxer sentbox conversation messages to the sentbox" do
      @stewie.messages_in_sentbox.collect(&:subject).should eq(
        ["RE: Message To Stewie Two", "RE: Message To Stewie Four", 
          "Message To Ricon Four", "Message To Ricon Three", 
          "Message To Ricon Two", "Message To Ricon One"] )
    end

    it "should match the mailboxer trash conversation messages to the trash" do
      @stewie.messages_in_trash.collect(&:subject).should eq(
        [ 'RE: Message To Ricon Four', 'Message To Stewie Three' ] )
    end
  end

  describe "feedback counts" do
    before do
      @ricon = FactoryGirl.singleton_user :user_ricon
      # No feedback:
      create :ricons_purchase_item_sent
      create :stewies_purchase_item_sent

      # Feedback:
      create :ricons_purchase_with_purchaser_feedback
      create :stewies_purchase_with_seller_feedback
      create :ricons_purchase_with_purchaser_feedback, :rating_on_purchaser => -1
      create :stewies_purchase_with_seller_feedback, :rating_on_seller => 1 
    end
    after{Item.destroy_all; Purchase.destroy_all;}

    it "should list user's feedback as a seller" do
      @ricon.feedback_as_seller.should eq(
        {:total => 2, :positive => 1, :negative => 1} )
    end

    it "should list user's feedback as a buyer" do
      @ricon.feedback_as_buyer.should eq(
        {:total => 2, :positive => 1, :negative => 1} )
    end
    
    it "should list user's aggregate feedback" do
      @ricon.feedback.should eq(
        {:total => 4, :positive => 2, :negative => 2} )
    end
  end

  describe "admin finder" do
    before{ FactoryGirl.singleton_user :site_admin }
    after{ User.destroy_all }

    it "should find the site admin user" do
      User.site_admin.email.should eq('info@coinpost.com') 
    end
  end

end

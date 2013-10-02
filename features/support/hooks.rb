Before('@seed_categories') do
  FactoryGirl.create_category_tree
end

Before('@seed_policies') do
  FactoryGirl.seed_shipping_policies
  FactoryGirl.seed_return_policies
end

Before('@seed_users') do
  FactoryGirl.seed_users
end

Before('@seed_items') do
  FactoryGirl.create_seed_items(50)
end

Before('@seed_stewie_user') do
  FactoryGirl.singleton_user :user_stewie
end

Before('@seed_stewie_items') do
  @stewie = FactoryGirl.singleton_user :user_stewie
  FactoryGirl.singleton_user :user_ricon

  FactoryGirl.create_sixty_days_ago_item(:title => "Stewie's Expired Shiny Widget")
  FactoryGirl.create :twenty_days_in_future_item ,
    :title => "Stewie's Pending Shiny Widget"
  FactoryGirl.create :disabled_item, :title => "Stewie's Disabled Shiny Widget"
 
  item_with_sales = FactoryGirl.create :item, :title => "Stewie's Shiny Widget With Sales", 
    :quantity_listed => 5
  item_with_sales.purchases.create :quantity_purchased => 1, 
    :purchaser => FactoryGirl.singleton_user(:user_ricon)
  
  sold_out_item = FactoryGirl.create :item, :title => "Stewie's Sold Out Widget", 
    :quantity_listed => 2
  sold_out_item.purchases.create :quantity_purchased => 2, 
    :purchaser => FactoryGirl.singleton_user(:user_ricon)

  FactoryGirl.create :item, :title => "Stewie's Shiny Widget"
end

Before('@seed_stewie_reddit_items') do
  FactoryGirl.create :item, :title => "Stewie's Shiny Widget On Reddit", 
    :reddit_url => 'http://www.reddit.com/r/BitMarket/comments/1cag2j/wts_xbox_360_slim_4_gb_black_new_in_box/'
end

Before('@seed_purchases') do
  @purchases = {}
  %w(stewies ricons).each do |u| 
    %w( 
    purchase purchase_payment_sent purchase_item_sent purchase_item_sent_no_payment 
    ).each{|p| 
      key = [u,p].join('_').to_sym
      
      @purchases[key] = FactoryGirl.create key
    }
  end
end

Before('@seed_feedback') do
  @purchases ||= {}
  %w(ricons_purchase_with_seller_feedback ricons_purchase_with_purchaser_feedback).each do |p|
    @purchases[p.to_sym] = FactoryGirl.create p.to_sym
  end
end

Before('@seed_stewie_item_images') do
  Item.all.each do |item|
    # A simple stewie item image
    image = item.images.build :image => File.new('spec/assets/ubuntu-logo.png')
    image.creator = @stewie
    image.save
  end
end

Before('@seed_item_widget') do
  FactoryGirl.create :shiny_widget_item
end

Before('@seed_stewie_emails') do
  @stewie = FactoryGirl.singleton_user :user_stewie
  @ricon = FactoryGirl.singleton_user :user_ricon
  
  @stewie.send_message @ricon, 'Seed Message for testing.', 'Message To Ricon One'
  @stewie.send_message @ricon, 'Seed Message for testing.', 'Message To Ricon Two'

  @ricon.send_message @stewie, 'Seed Message for testing.', 'Message To Stewie One'
  @ricon.send_message @stewie, 'Seed Message for testing.', 'Message To Stewie Two'

  @ricon.send_message @stewie, 'Seed Message for testing.', 'Message To Stewie Three'
  @stewie.trash @stewie.mailbox.inbox.to_a.find{|msg| 
    msg.subject == 'Message To Stewie Three'
  }


end

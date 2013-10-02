
[
['Fashion', %w(Hats Shirts Pants Shoes Dresses Winter\ Apparrel Sports\ Apparrel Accessories) ],
['Motors', %w(Automotive Motorcycles Accessories)],
['Computers & Gaming', %w(Consoles PCs Video\ Games Parts)],
['Electronics', %w(Video Audio Cables)],
['Collectibles & Art', %w(Trading\ Cards Comics Memorabilia)],
['Home & Decor',  %w(Tools Holiday\ Decorations Appliances)],
['Entertainment', %w(Movies Music Books Audio\ Books)],
['Miscellaneous', %w()],
['Services', %w(Computer Legal Accounting)],
].each do |pairs|
  title, subtitles = pairs
  parent = Category.create(:title => title)
  
  puts 'Creating Category "%s"' % title

  subtitles.each do |sub_title|
    Category.create(:title => sub_title, :parent => parent)
  end
end

require "factory_girl"
require "delorean"

%w(user shipping_policy return_policy item).each do |factory|
  require Rails.root.join('spec','factories',factory)
end

puts "Creating Users"
FactoryGirl.seed_users

puts "Creating Shipping Policies"
FactoryGirl.seed_shipping_policies

puts 'Creating Return Policies...'
FactoryGirl.seed_return_policies

now = Time.now.utc 
sixty_days_ago = now-24*3600*60
sixty_days_from_now = now+24*3600*20

Delorean.time_travel_to(sixty_days_ago) do
  print "Creating 200 expired items"
  FactoryGirl.create_seed_items(200) do
    print '.'
  end
end
puts

print "Creating 2000 active items"
FactoryGirl.create_seed_items(2000) do
  print '.'
end
puts

Delorean.time_travel_to(sixty_days_from_now) do
  print "Creating 200 future items"
  FactoryGirl.create_seed_items(200) do
    print '.'
  end
end

puts
users = User.where('email != ?', 'rickonstark@spectest.com')
user_i = -1

puts "Giving Ricon some item sales"
ricon = User.where(:email => 'rickonstark@spectest.com').first
ricon.items.order('expires_at ASC').each_with_index do |item, i|
  if (i % 3) == 0
    print '.'
    item.quantity_listed = 5
    item.save!

    user_i = (user_i >= users.length) ? 0 : (user_i + 1)

    item.purchases.create :purchaser => users[user_i], :quantity_purchased => 1
  end
end
puts

puts "Fulfilling some of ricon's sales"
ricon_unfulfilled = Purchase.created_by(ricon).unfulfilled
ricon_unfulfilled[0...20].each_with_index do |purchase, i|
  print '.'
  
  purchase_edit = Purchase.find(purchase.id)
  purchase_edit.item_sent_at = Time.now.utc
  purchase_edit.save!
end
puts

puts "Ricon's making some purchases of his own"
Item.purchaseable.where([ 'creator_id != ?', ricon.id ] ).limit(20).each do |item|
  print '.'
  item.purchases.create :purchaser => ricon, :quantity_purchased => 1
end
puts

puts "Marking 20% of these as paid"
Purchase.purchased_by(ricon).unpaid.each_with_index do |purchase, i|
  if (i % 5) == 0
    print '.'
    purchase_edit = Purchase.find(purchase.id)
    purchase_edit.payment_sent_at = Time.now.utc
    purchase_edit.save!
  end
end
puts

puts "Leaving feedback on Ricon's buys"
Purchase.purchased_by(ricon).paid[0...4].each_with_index do |purchase, i|
  print '.'
  p = Purchase.find(purchase.id)
  if i % 2 == 0
    p.rating_on_purchaser = 1
    p.comment_on_purchaser = "Good Buyer"
  else
    p.rating_on_purchaser = -1
    p.comment_on_purchaser = "Bad Buyer"
  end
  p.save!
end
puts

puts "Leaving feedback on Ricons sales"
Purchase.created_by(ricon).fulfilled[0...4].each_with_index do |purchase, i|
  print '.'
  p = Purchase.find(purchase.id)
  if i % 2 == 0
    p.rating_on_seller = 1
    p.comment_on_seller = "Good Seller"
  else
    p.rating_on_seller = -1
    p.comment_on_seller = "Bad Seller"
  end
  p.save!
end


users = User.all 
puts "Sending emails"
3.times do
  users.each do |sender|
    users.each do |recipient|
      next if recipient == sender
      print '.'      
      sender.send_message(
        recipient, 
        "This is a message. A message which says \"Hello\". Hello.", 
        "RE: Hello %s" % recipient.name
      )
    end
  end
end
puts

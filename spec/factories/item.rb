FactoryGirl.define do
  factory :item do
    title "Chia Pet"
    location "New York, NY"

    description "This lovable pet <strong> only requires <strong>Sunshine and water"
    price_in_btc "8"
    quantity_listed 5

    # Taken from: https://en.bitcoin.it/wiki/Address
    btc_receive_address '37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare'

    # Remember that this needs to be slightly in the future or else we'll fail
    # validation, seeing that the create occurred in the past
    lists_at { Time.now.utc }
    expires_at { self.lists_at + 3600*24*7 }

    creator { FactoryGirl.singleton_user(:user_stewie) } 

    shipping_policy { ShippingPolicy.find_by_label('None') }
    return_policy { ReturnPolicy.find_by_label('None') }

    categories {[:electronics_category, :decorations_category].collect{|c| 
      FactoryGirl.singleton_category(c)
    }}

    factory :shiny_widget_item do
      title "Shiny Widget"
      description "This widget's got some polish"
    end

    factory :disabled_item do
      title 'Disabled'
      enabled false
    end

    factory :enabled_item do
      title 'Enabled'
      enabled true
    end

    factory :twenty_days_in_future_item do
      title 'Twenty days from now'
      lists_at { Time.now.utc+24*3600*20 }
    end

    factory :ricon_item do
      creator { FactoryGirl.singleton_user(:user_ricon) } 
    end

    factory :currency_test_item do
      title 'Currency Test'
      price_in_currency( { :price => '1', :currency => 'USD' } )
    end
  end
end

module FactoryGirl

  # This is kind of sloppy, but it works for now, keeps things DRY
  def self.create_sixty_days_ago_item(opts = {})
    sixty_days_ago = Time.now.utc-24*3600*60

    item = nil
    Delorean.time_travel_to(sixty_days_ago) do
      item = create :item, 
        {:title => 'Sixty days ago', :lists_at => sixty_days_ago}.merge(opts)
    end

    item
  end

  def self.create_seed_items(quantity, &block)
lorem_ipsum = <<EOD
<p>Lorem <strong>ipsum dolor sit amet</strong>, consectetur adipiscing elit. Morbi eget faucibus orci. Proin nec egestas lorem. Sed eu sapien magna, nec aliquet diam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu magna eget magna blandit laoreet. Praesent est lorem, convallis sit amet sagittis non, tempor rhoncus massa. Ut consequat ipsum at neque bibendum malesuada. Morbi elit tortor, pellentesque ac accumsan non, porttitor at eros. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris risus dui, hendrerit quis ultricies vel, gravida nec purus. Praesent sed ante eros, at porta urna.</p>

<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis metus urna, suscipit nec dignissim non, gravida at magna. Fusce dui est, eleifend quis ornare ac, lacinia in velit. In at nunc sapien, et interdum enim. Sed iaculis dictum malesuada. Aenean mollis adipiscing felis at tristique. Maecenas magna elit, feugiat ac mattis eu, interdum vitae libero. Mauris sit amet turpis libero. Vestibulum nec dolor vitae tellus imperdiet feugiat. Proin venenatis eros vel ipsum suscipit ornare. Cras at nisl est, vel laoreet leo. Donec vel felis ac nulla blandit condimentum non et est. Aenean facilisis eleifend fermentum.</p>

<p>Fusce elit turpis, volutpat vel condimentum eu, eleifend ornare risus. Praesent in nibh at nisl placerat rutrum ac at odio. Nunc augue lorem, laoreet vitae volutpat id, ultricies id orci. Donec vitae dolor neque, quis vulputate magna. Duis nisl enim, varius eget dignissim vel, hendrerit ac massa. Sed sollicitudin mollis semper. Ut dictum pellentesque lorem, vitae lobortis arcu pharetra eget. Ut placerat velit non mi ultrices aliquam. Cras vitae tortor eget justo molestie auctor et sed turpis. Etiam iaculis adipiscing magna vitae rhoncus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse iaculis, purus vitae imperdiet fermentum, dolor est iaculis nisi, id congue enim erat non quam.</p>

<p>Maecenas scelerisque libero quis nulla gravida in fermentum justo lobortis. Maecenas at metus ut dolor placerat suscipit. Nam ut elit eget massa facilisis condimentum. Maecenas ut massa ut urna adipiscing congue eget eu nisi. Cras suscipit quam id purus condimentum non dapibus est fermentum. Cras posuere ornare volutpat. Maecenas pharetra lacinia augue, ut porttitor erat iaculis vel. Quisque id imperdiet est. Nam placerat tristique facilisis. Nunc in odio quis nibh elementum luctus in ac est.</p>

<p>Pellentesque sit amet est at nisi feugiat semper. Aenean tempor volutpat pretium. Aliquam non libero at lorem cursus imperdiet. Aenean lobortis sodales convallis. Phasellus vehicula purus sit amet tellus ultrices fringilla. Nunc laoreet lobortis consequat. Nunc dictum vehicula tristique. Sed a mi nibh, in placerat felis.</p>
EOD
    locations = ['Miami, FL', "New York", "London, UK", 'California', 'Mexico']

    categories = Category.all
    shipping_policies = ShippingPolicy.all
    return_policies = ReturnPolicy.all
    users = User.all

    shipping_policies << nil
    return_policies << nil

    words = File.open('/usr/share/dict/words').readlines
    word_inc = words.length / (quantity * 2)

    item_images = Dir.glob('db/seed-images/*.*').to_a
    item_images << nil

    1.upto(quantity) do |i|
      item_name = [ 
        words[word_inc*i], words[words.length-word_inc*i] 
      ].collect{|w| w.strip.capitalize}.join(' ')

      item = Item.new(
        :title => item_name,
        :location => locations[i % locations.length],
        :description => lorem_ipsum,
        :price_in_btc => i.to_s,
        :quantity_listed => (i%8+1),
        :btc_receive_address => '37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare',
        :shipping_policy_id => 
          shipping_policies[i % shipping_policies.length].try(:id),
        :return_policy_id => 
          return_policies[i % return_policies.length].try(:id),
        :category_ids => [
          categories[i % categories.length].id
        ]
      )

      item.lists_at = Time.now.utc
      item.expires_at = item.lists_at + 3600*24*(7+(i % 24))
      item.creator = users[i % users.length]

      image_src = item_images[i % item_images.length] 
      if image_src
        image = ItemImage.new :image => File.new(image_src)
        image.creator = item.creator  
        item.images = [image]
      end

      block.call(item) if block
      item.save!
    end


  end
end

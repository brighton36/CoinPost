namespace :coinpost do
  desc 'Resize the item images'
  task :resize_item_images => :environment do
    total = ItemImage.count
    i = 0
    ItemImage.includes(:item).find_in_batches do |images| 
      images.each do |image|
        puts "Processing %s (%s/%s)..." % [image.item.title, i += 1, total]
        image.image.recreate_versions! 
        # This saves the new dimensions:
        image.save!
      end
    end
  end
end

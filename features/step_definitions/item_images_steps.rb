def post_ubuntu_image(to_url, driver)
  driver.header 'Accept', 'application/json, text/javascript;'

  driver.post(
    to_url, 
    'item_image[image]' => Rack::Test::UploadedFile.new(
      'spec/assets/ubuntu-logo.png', "image/png" )
  )
end

def json_get(url, driver)
  driver.header 'Accept', 'application/json, text/javascript;'
  driver.get url
end

When /^I upload an image to a new item$/ do
  post_ubuntu_image '/items/images', page.driver
end

When /^I upload an image to the stewie "([^"]*)" item$/ do |label|
  post_ubuntu_image( 
    [ '/items', stewie_item_slugs(label), 'images' ].join('/'),
    page.driver
  )
end

Then /^I should receive a "([^"]*)" status code$/ do |code_label|
  codes = {'sucessful' => 200, 'delete sucessful' => 204, 'unauthorized' => 401}
  page.driver.status_code.should eq(codes[code_label])
end

When /^I remove an image from the stewie "([^"]*)" item$/ do |label|
  image = Item.find(stewie_item_slugs(label)).images.first

  json_get [ '/items/images', image.id, 'delete' ].join('/'), page.driver
end

When /^I remove an image from a new item$/ do
  image = ItemImage.new :image => File.new('spec/assets/ubuntu-logo.png')
  image.creator = @stewie
  image.save

  json_get [ '/items/images', image.id, 'delete' ].join('/'), page.driver
end

When /^I list the images in a new item$/ do
  json_get '/items/images', page.driver
end

When /^I list the images in the stewie "([^"]*)" item$/ do |label|
  json_get [ '/items/', stewie_item_slugs(label), 'images' ].join('/'), page.driver
end


class ItemImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Meta

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    [ 
      'images',
      model.class.to_s.pluralize.underscore.tr('_','-'), 
      model.id
    ].join('/')
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  process :store_meta

  # Create different versions of your uploaded files:
  version(:upload_list_thumb) do
    process :resize_to_fill => [80,60] 
    process :store_meta
  end

  version(:item_detail_large) do 
    process :resize_to_fill => [264,195]
    process :store_meta
  end

  version(:item_detail_small) do
    process :resize_to_fill => [40,30]
    process :store_meta
  end

  version(:category_listing_small) do 
    process :resize_to_fill => [140,105]
    process :store_meta
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end

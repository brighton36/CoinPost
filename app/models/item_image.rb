class ItemImage < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :item

  validates :creator_id, :presence => true

  attr_accessible :image

  scope :in_item_for_user, lambda{ |user, item| 
    where(
      :creator_id => user.id, 
      :item_id => ( item.kind_of? Item ) ? item.id : item 
    ).order('created_at ASC') 
  }
  
  scope :editable_for_user, lambda{ |user, image| 
    includes(:item).where( [
      [
      'item_images.id = ?',
      'item_images.creator_id = ?',
      '(item_images.item_id IS NULL OR (items.expires_at > ? AND items.enabled = ?) )'
      ].join(' AND '),
      ( image.kind_of? ItemImage ) ? image.id : image,
      user.id, 
      Time.now.utc,
      true
    ] )
  }

  include Rails.application.routes.url_helpers
  mount_uploader :image, ItemImageUploader

  def to_jq_upload
    {
      :name => read_attribute(:image),
      :size => image.size,
      :url  => image.url,
      :thumbnail_url => image.upload_list_thumb.url,
      :delete_url => (item_id) ? 
        item_image_path(:id => id, :item_id => item_id) : 
        destroy_image_items_path(:id => id),
      :delete_type => "DELETE" 
    }
  end
end

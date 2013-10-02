class AddMetaToItemImages < ActiveRecord::Migration
  def change

    %w(width height file_size).each do |meta|
      add_column :item_images, ('image_%s' % [meta]).to_sym, :string
      
      %w(upload_list_thumb item_detail_large item_detail_small 
        category_listing_small).each do |version|
          add_column :item_images, ('image_%s_%s' % [version, meta]).to_sym, :integer
      end
    end

  end
end

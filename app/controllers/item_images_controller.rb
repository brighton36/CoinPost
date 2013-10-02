class ItemImagesController < ApplicationController
  filter_access_to :destroy, :attribute_check => true, 
    :load_method => lambda { |c|
      @item_image = ItemImage.editable_for_user( 
        current_user, 
        params[:id].to_i 
      ).first if current_user 
    }

  filter_access_to :create, :attribute_check => true, 
    :load_method => lambda { |c|
      @item_image = ItemImage.new params[:item_image]
      @item_image.creator = current_user
      if params.key?(:item_id) && current_user
        @item_image.item = Item.current_or_pending.where(
          :enabled => true, 
          :slug => params[:item_id].to_s, 
          :creator_id => current_user.id
        ).first
        
        raise ::Authorization::AttributeAuthorizationError if @item_image.item.nil?
      end
      
      @item_image
    }

  filter_access_to :index, :attribute_check => true,
    :load_method => lambda { |c|
      if params.key? :item_id
        @item = Item.find params[:item_id]
        raise AttributeAuthorizationError if @item.nil?
      end

      @item || Item.new
    }

  filter_access_to :all

  respond_to :json 

  def index
    @item_images = ItemImage.in_item_for_user current_user, @item

    respond_with @item_images do |format|
      format.json do
        render :json => @item_images.collect{ |p| p.to_jq_upload }
      end
    end
  end

  def create
    respond_with @item_image.save do |format|
      render_args = (@item_image.valid?) ?
        {:json => [@item_image.to_jq_upload]} :
        {:json => [{:error => "custom_failure"}], :status => 304} 

      # This format.html block exists because IE9 uses an IFRAME to request this
      # data, which means that an html request gets sent to us:
      format.html{ render render_args.merge({:content_type => 'text/plain'}) }
      format.json{ render render_args }
    end
  end

  def destroy
    respond_with @item_image.destroy do |format|
      format.json{ render :json => true, :status => 204 }
    end
  end
end

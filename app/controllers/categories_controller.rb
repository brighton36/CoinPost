class CategoriesController < ApplicationController
  filter_access_to :all

  respond_to :html

  def show
    @category = ( params.has_key? :id ) ?
      Category.find( params[:id], :include => :parent ) : nil

    @items = (
      (@category) ? @category.purchaseable_items_including_descendants : 
        Item.purchaseable.order('items.expires_at ASC')
    ).includes(:images).page params[:page]

    respond_with @category do |format|
      format.html { render :action => :show }
      format.rss  { render :action => :show, :layout => false }
      format.atom { render :action => :show, :layout => false }
    end
  end

  alias_method :index, :show

  private

end

class DashboardController < ApplicationController
  filter_access_to :all

  respond_to :html  

  ITEM_FINDERS = [ :pending, :active, :expired ]

  def index
    @purchase_tables = {
      :unpaid => Purchase.purchased_by(current_user).unpaid,
      :unfulfilled => Purchase.created_by(current_user).unfulfilled
    }
    
    @unread_messages = current_user.messages_in_inbox.unread

    @item_tables = Hash[ ITEM_FINDERS.collect{ |type| [type, item_finder(type)] } ]

    respond_to do |format|
      format.html { render :action => :index }
    end
  end

  ITEM_FINDERS.each do |type|
    define_method( ('%s_items' % type).to_sym ) do
      @items, @table = item_finder(type), type

      respond_with @items do |format|
        format.html { render :action => :items_listing }
      end
    end    
  end

  private
  def item_finder(type)
    finder = case type
      when :pending then Item.pending
      when :active then Item.purchaseable.order('items.expires_at ASC')
      when :expired then 
        Item.order('expires_at DESC').unpurchaseable.not_pending
    end

    finder.created_by current_user
  end
end

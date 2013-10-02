module CategoriesHelper
  def active_header; :buy; end

  def title_params
    {:title => @category.title, :count => @category.purchaseable_item_count} if @category
  end

  def block_params_left
    [ [:cell, :categories, :show, :category => @category] ]
  end

  def resource_assets
    %w(atom rss).collect do |feed|
      auto_discovery_link_tag( feed.to_sym, url_for(:action => action_name, 
        :controller => controller_name, :format => feed) )
    end if /\A(?:index|show)\Z/.match action_name 
  end

  def category_updated_at
    @items.order('updated_at DESC').try(:first).try(:updated_at) || @category.update_at
  end
end

module HomeHelper
  def block_params_left
    [ [:cell, :categories, :show] ]
  end

  def active_header 
    action_name.to_sym
  end

  def resource_assets
    assets = []
    assets << tinymce_assets if action_name == 'help' && current_user

    assets += %w(atom rss).collect do |feed|
      auto_discovery_link_tag( feed.to_sym, url_for(:action => :index, 
        :controller => :categories, :format => feed) )
    end

    assets
  end
end

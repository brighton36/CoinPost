xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag! 'atom:link', :href => url_for(:only_path => false, :format => 'rss'), :rel=>"self", 
      :type=>"application/rss+xml"
    xml.title ( @category.try(:title) || t('.all_categories') )
    xml.description t('.rss_description', :category => (@category.try(:title) || t('.all_categories')) )
    xml.link url_for( (@category) ? 
      {:action => :show, :id => @category.to_param, :only_path => false} : 
      {:action => :index, :only_path => false} ) 

    for item in @items
      xml.item do
        item_link = url_for :controller => :items, :action => :show, 
          :id => item.to_param, :only_path => false
        xml.title item.title
        xml.description item.description
        xml.pubDate item.lists_at.to_s(:rfc822)
        xml.link item_link 
        xml.guid item_link
      end
    end
  end
end

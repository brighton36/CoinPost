atom_feed :language => 'en-US' do |feed|
  feed.title( @category.try(:title) || t('.all_categories') )
  feed.updated category_updated_at

  @items.each do |item|
    # We do this funky tap so that atom_feed doesn't output an updated_at
    # and allows us to write a UTC updated at instead:
    feed.entry( item.dup.tap{ |i| i.updated_at = nil} ) do |entry|
      entry.title item.title
      entry.content item.description, :type => 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author{ |author| author.name item.creator.name }
    end
  end
end

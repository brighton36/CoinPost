FactoryGirl.define do
  factory(:category) do
    title 'Test Category'

    factory(:electronics_category){ title "Electronics" }
    factory(:electronics_subcategory) do
      parent { FactoryGirl.singleton_category :electronics_category }

      factory(:video_category) { title "Video" }
      factory(:audio_category) { title "Audio" }
      factory(:cables_category){ title "Cables" }
    end

    factory(:decorations_category){ title "Home Decorations" }
    factory(:decorations_subcategory) do
      parent { FactoryGirl.singleton_category :decorations_category }

      factory(:tools_category)     { title "Tools" }
      factory(:holiday_category)   { title "Holiday Decorations" }
      factory(:appliances_category){ title "Appliances" }
    end

    factory(:entertainment_category){ title "Entertainment" }
    factory(:entertainment_subcategory) do
      parent { FactoryGirl.singleton_category :entertainment_category }

      factory(:movies_category)    { title "Movies" }
      factory(:music_category)     { title "Music" }
      factory(:books_category)     { title "Books" }
      factory(:audiobooks_category){ title "Audio Books" }
    end

    factory(:collectibles_category) { title "Collectibles" }
    factory(:collectibles_subcategory) do
      parent { FactoryGirl.singleton_category :collectibles_category }

      factory(:tradingcards_category) { title "Trading Cards" }
      factory(:comics_category)       { title "Comics" }
      factory(:memorabilia_category)  { title "Memorabilia" }
    end
  end
end

module FactoryGirl
  def self.singleton_category(name)
    Category.where(:title => build(name).title).first || create(name)
  end

  def self.create_category_tree
    [
    [:electronics_category, :video_category, :audio_category, :cables_category],
    [:decorations_category,:tools_category,:holiday_category,:appliances_category],
    [:entertainment_category,:movies_category,:music_category,:books_category,
      :audio_category],
    [:collectibles_category,:tradingcards_category,:comics_category, 
      :memorabilia_category]
    ].flatten.inject(Hash.new){ |ret,cat| 
      ret.merge({cat => FactoryGirl.singleton_category(cat)})
    }
  end
end


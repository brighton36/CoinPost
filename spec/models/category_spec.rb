require 'spec_helper'

describe Category do

  describe "scopes" do

    after { Item.delete_all; Category.delete_all }

    it "should display purchaseable items in category and descendants" do
      @now = Time.now.utc 
      sixty_days_ago = @now-24*3600*60
      twenty_days_in_the_future = @now+24*3600*20

      # Create expired product
      Delorean.time_travel_to(sixty_days_ago) do
        create :item, :lists_at => sixty_days_ago
      end

      # Create product that has yet to list:
      create :item, :lists_at => twenty_days_in_the_future
      categories = FactoryGirl.create_category_tree
      
      create :item, :title => 'Item D', :lists_at => @now-3300,
        :categories => [categories[:tools_category] ]
      create :item, :title => 'Item C', :lists_at => @now-3300,
        :categories => [categories[:decorations_category] ]
      
      # These products are the only one that should match:
      # currently, we only care about one level of recursion
      create :item, :title => 'Item A', :lists_at => @now-3500, 
        :categories => [categories[:electronics_category] ]
      create :item, :title => 'Item B', :lists_at => @now-3400,
        :categories => [categories[:video_category] ]

      electronics = FactoryGirl.singleton_category(:electronics_category)
      electronics.purchaseable_items_including_descendants.collect(&:title).should(
        eq(%w(Item\ A Item\ B)) )
    end
  end

  describe "tree methods" do

    it "shouldn't break tree_as_options when there are no categories" do
      Category.tree_as_options.should eq( [] )
    end

    it "shouldn't break tree when there are no categories" do
      Category.tree.should eq( [] )
    end
   
    context "with populated tree" do
      before do 
        FactoryGirl.create_category_tree

        # We use this for items:
        @electronics = Category.where(:title => 'Electronics').first
        @video = Category.where(:title => 'Video').first
        @audio = Category.where(:title => 'Audio').first
        @collectibles = Category.where(:title => 'Collectibles').first
        
        [ 
          [@electronics], [@electronics], [@electronics, @video], [@audio, @collectibles], 
          [@audio], [@video]
        ].each{ |cats| FactoryGirl.create :shiny_widget_item, :categories => cats }
      end
      after{ Category.delete_all }

      it "tree should return the level+category of the entire tree" do
        Category.tree.collect{|c| [ c[0], c[1].title ] }.should eq(
          [[0, "Electronics"], [1, "Video"], [1, "Audio"], [1, "Cables"], [0, "Home Decorations"], [1, "Tools"], [1, "Holiday Decorations"], [1, "Appliances"], [0, "Entertainment"], [1, "Movies"], [1, "Music"], [1, "Books"], [0, "Collectibles"], [1, "Trading Cards"], [1, "Comics"], [1, "Memorabilia"]] )
      end

      it "tree should process a single branch" do
        Category.tree(@electronics.descendants.all).collect{|c| 
          [ c[0], c[1].title ] 
        }.should eq([[0, "Video"], [0, "Audio"], [0, "Cables"]])
      end

      it "tree as options should match the awesome nested_set_options" do
        class DummyHelper < ActionView::Base; end
        
        awesome_tree = DummyHelper.new.nested_set_options(Category, nil){|i| 
          ['- ' * i.level,i.title].join }

        Category.tree_as_options.should eq( awesome_tree )
      end
      
      it "should query the categories with purchaseable item counts" do
        Category.with_purchaseable_item_counts.collect{|c| 
          [ c[0].title, c[1]] 
        }.should eq([["Electronics", 7], ["Home Decorations", 0], ["Entertainment", 0], ["Collectibles", 1]])
      end

      it "should query the subcategory with purchaseable item counts" do
        Category.with_purchaseable_item_counts(@electronics).collect{|c| 
          [ c[0].title, c[1]] 
        }.should eq([["Video", 2], ["Audio", 2], ["Cables", 0]])
      end

      it "shouldn't freak when querying a category with no subcategories" do
        Category.with_purchaseable_item_counts(@video).should eq([])
      end
    end
  end

end

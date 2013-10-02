require 'spec_helper'

describe ItemImage do
  describe "scopes" do
    before{ 
      @me = create :user
      @my_image = create :item_image, :creator => @me
      @my_item = create :item
      @my_item_images = (1..5).collect{
        create :item_image, :item => @my_item, :creator => @me
      }

      @my_disabled_item = create :item
      @my_disabled_item.enabled = false
      @my_disabled_item.save
      @my_disabled_image = build :item_image, :item => @my_item, :creator => @me

      @stewie = FactoryGirl.singleton_user(:user_stewie)
      @stewie_new_images = (1..5).collect{create :item_image, :creator => @stewie}
      @stewie_item = create :item
      @stewie_item_images = (1..5).collect{
        create :item_image, :item => @stewie_item, :creator => @stewie
      }
    } 
    after{ [ItemImage,User].each{|k| k.destroy_all } }

    it "find images not attached to an item, belonging to a user" do
      ItemImage.in_item_for_user(@me, nil).collect(&:id).should eq([@my_image.id])
    end

    it "find images attached to an item, belonging to a user" do
      ItemImage.in_item_for_user(@me, @my_item).collect(&:id).should(
        eq(@my_item_images.collect(&:id))
      )
    end

    it "finds images belonging to a user" do
      ItemImage.editable_for_user(@me, @my_image.id).first.id.should eq(@my_image.id)
    end
    
    it "doesn't find images belonging to another user" do
      ItemImage.editable_for_user(@me, @stewie_new_images[0].id).should be_empty
    end

    it "doesn't find images belonging to user after item expires" do
      Delorean.time_travel_to(@my_item.expires_at + 3600) do
        ItemImage.editable_for_user(@me, @my_item_images[0].id).should be_empty
      end
    end

    it "does find images belonging to user before item lists" do
      Delorean.time_travel_to(@my_item.lists_at - 7200) do
        image_id = @my_item_images[0].id
        ItemImage.editable_for_user(@me, image_id).first.id.should eq(image_id)
      end
    end
    
    it "shouldn't find disabled items" do
      ItemImage.editable_for_user(@me, @my_disabled_image.id).length.should eq(0)
    end
  end

end

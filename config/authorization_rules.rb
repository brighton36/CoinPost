Authorization::Reader::AuthorizationRulesReader.class_eval do
  # This is just to DRY out the above specifications:
  def showable_item_acls
    # Note the individually delineated if_attribute's are OR'd
    if_attribute :is_pending => false
    if_attribute :is_expired => true 
    if_attribute :enabled => false
  end
end

authorization do
  role :guest do
    has_permission_on :home, :to => [:index, :get_coins, :about_us, :help, :ask_question]
    has_permission_on :categories, :to => [:show, :index]
    has_permission_on :users, :to => :show
    has_permission_on(:items, :to => :show) { showable_item_acls }
    has_permission_on :registrations, :to => [:new, :create]
  end
  
  role :registered_user do
    includes :guest

    has_permission_on :registrations, :to => [:edit, :update]
    has_permission_on :dashboard, 
      :to => [ :index, :active_items, :pending_items, :expired_items]

    # Item Management
    has_permission_on :items, :to => [:preview, :add_images, :new, :create]
    has_permission_on :items, :to => :show do
      if_attribute :creator => is {user}, :is_pending => true
    end
    has_permission_on :items, :to => [:edit, :update, :edit_images, :update_images] do
      if_attribute :creator => is {user}, :is_purchaseable => true 
      if_attribute :creator => is {user}, :is_pending => true
    end
    has_permission_on :items, :to => [:submit_to_reddit] do
      if_attribute :creator => is {user}, :is_purchaseable => true,
        :reddit_url => is { nil }, :is_pending => false
    end
    has_permission_on :items, :to => :destroy do
      if_attribute :creator => is {user}, 
        :has_sales => false, :is_expired => false, :enabled => true
    end  
    has_permission_on :items, :to => :relist do
      if_attribute(
        :creator => is {user}, :is_purchaseable => false, 
        :is_pending => false
      )
    end
    has_permission_on :items, :to => :disable do
      if_attribute( 
        :creator => is {user}, :is_purchaseable => true, :has_sales => true
      )
    end

    # Item Image Management
    has_permission_on :item_images, :to => [:index] do
      # Editing an existing item:
      if_attribute :creator => is {user}
      # New item listing:
      if_attribute :id => nil
    end
    has_permission_on :item_images, :to => [:create] do
      if_attribute :item => { :creator => is {user}, :is_expired => false, 
        :enabled => true }
      if_attribute :item_id => nil
    end
    has_permission_on :item_images, :to => :destroy do
      if_attribute :creator => is {user}, :item => {
        :is_expired => false, :enabled => true }
      if_attribute :creator => is {user}, :item_id => nil
    end
    
    # Messaging
    has_permission_on :messages, :to => :create
    has_permission_on :messages, :to => [:inbox, :trash, :sentbox] do
      if_attribute :id => is {user.id}
    end
    
    has_permission_on :messages, :to => [:show] do
      if_attribute :recipients => contains {user}
    end
    
    has_permission_on :messages, :to => [:reply, :create_reply] do
      if_attribute :recipients => contains {user}, :sender => is_not {user}
    end
   
    has_permission_on :messages, :to => [:trash_messages, :untrash_messages]
    
    has_permission_on :messages, :to => [:create_from_item]{ showable_item_acls }

    # Purchasing
    has_permission_on :purchases, :to => [:create] do
      if_attribute :is_purchaseable => true 
    end
    has_permission_on :purchases, 
      :to => [:unfulfilled, :fulfilled, :unpaid, :paid, :needs_feedback] do
      if_attribute :id => is {user.id}
    end
    has_permission_on :purchases, :to => [:mark_fulfilled] do
      if_attribute :item => {:creator => is {user}}, :item_sent_at => nil
    end
    has_permission_on :purchases, :to => [:mark_paid] do
      if_attribute :purchaser => is {user}, :payment_sent_at => nil
    end
    
    has_permission_on :purchases, :to => [:leave_feedback] do
      # There's a couple more checks in the controller, but these are the biggies:
      if_attribute :purchaser => is {user}, :rating_on_seller => 0
      if_attribute :item => { :creator => is {user} }, :rating_on_purchaser => 0
    end
  end
end


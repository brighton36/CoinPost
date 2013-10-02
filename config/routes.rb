CoinpostCom::Application.routes.draw do

  devise_for :users, :skip => [:sessions, :registrations]

  devise_scope :user do
    resource :registration, 
      :only => [:new, :create, :edit, :update], 
      :path => 'users',
      :path_names => { :new => 'sign_up' },
      :controller => 'registrations',
      :as => :user_registration do
      get :cancel
    end
  end

  as :user do
    get 'sign-in' => 'devise/sessions#new', :as => :new_user_session
    post 'sign-in' => 'devise/sessions#create', :as => :user_session
    delete 'sign-out' => 'devise/sessions#destroy', :as => :destroy_user_session

    # Cucumber can't seem to send delete requests, so we define this as
    # get in test mode:
    get 'sign-out' => 'devise/sessions#destroy' if Rails.env.test?
  end

  resources :users, :only => :show do

    resources :messages, :only => [:show, :create, :new ] do
      member do
        get  'reply' => 'messages#reply'
        post 'reply' => 'messages#create_reply'
      end
    end

    collection do
      # Message related
      get ':user_id/inbox' => 'messages#inbox', :as => :messages_inbox
      get ':user_id/trashed-messages' => 'messages#trash', :as => :messages_trash
      get ':user_id/sent-messages' => 'messages#sentbox',  :as => :messages_sentbox

      post ':user_id/trash-messages' => 'messages#trash_messages', 
        :as => :trash_messages
      post ':user_id/untrash-messages' => 'messages#untrash_messages', 
        :as => :untrash_messages
      
      # Payment related
      get ':user_id/sales/unfulfilled' => 'purchases#unfulfilled',
        :as => :sales_unfulfilled
      get ':user_id/sales' => 'purchases#fulfilled',
        :as => :sales_fulfilled
      get ':user_id/purchases/unpaid' => 'purchases#unpaid', 
        :as => :purchases_unpaid
      get ':user_id/purchases' => 'purchases#paid', :as => :purchases_paid
      get ':user_id/leave-feedback' => 'purchases#needs_feedback', :as => :needs_feedback

      post ':user_id/mark-fulfilled/:id' => 'purchases#mark_fulfilled', 
        :as => :mark_fulfilled
      post ':user_id/mark-paid/:id' => 'purchases#mark_paid', 
        :as => :mark_paid
      put ':user_id/leave-feedback/:id' => 'purchases#leave_feedback', 
        :as => :leave_feedback
    end
 
  end
  # need plural  
  get 'users/:id(.:format)' => 'users#show', :as => :users

  resources :items, :path_names => { :new => "sell" },
    :only => [:create, :edit, :update, :new, :destroy, :show ],
    :constraints => {:id => /[a-z0-9\-\_\/]+/i} do
    collection do 
      post 'preview'
      post 'add-images', :to => :add_images
      post 'sell', :to => :new # This is needed for the 'back' action submit

      # These are needed to create images on the new action
      post 'images', :to => 'item_images#create', :as => :create_image
      get  'images', :to => 'item_images#index'
      delete 'images/:id', :to => 'item_images#destroy', :as => :destroy_image
      
      # This is a hack to get capybara tests useable for deletes:
      get 'images/:id/delete', :to => 'item_images#destroy' if Rails.env.test?
    end

    member do
      post 'ask-question', :to => 'messages#create_from_item', 
        :as => 'ask_question'

      post 'submit-to-reddit', :to => :submit_to_reddit, :as => :submit_to_reddit
      post 'disable',      :to => :disable
      get 'relist',        :to => :relist,        :as => :relist
      get 'edit-images',   :to => :edit_images,   :as => :edit_images
      put 'update-images', :to => :update_images, :as => :update_images

      post 'purchase', :to => 'purchases#create', :as => :purchase

      # This is a hack to get capybara tests useable for deletes:
      get 'delete', :to => :destroy if Rails.env.test?
    end
  
    resources :item_images, :path => "images", :as => :images,
      :only => [:index, :create, :destroy]
  end

  resources :categories, :only => [:show,:index], :id =>  /[0-9a-z\-\/]+/i
  resources :dashboard,  :only => [ :index ]  do
    collection do
      get 'active-items',  :to => :active_items,  :as => :active_items 
      get 'pending-items', :to => :pending_items, :as => :pending_items
      get 'expired-items', :to => :expired_items, :as => :expired_items
    end
  end

  post 'ask-question' => 'home#ask_question', :as => :ask_question
  get 'about-us' => 'home#about_us', :as => :about_us
  get 'get-coins' => 'home#get_coins', :as => :get_coins
  get 'help' => 'home#help', :as => :help
  root :to => "home#index"
end

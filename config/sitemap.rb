Sitemap::Generator.instance.load :host => "www.coinpost.com", :protocol => 'https' do
  path :root,      :priority => 1, :change_frequency => :daily
  path :about_us,  :priority => 0.75
  path :get_coins, :priority => 0.75
  path :help,      :priority => 0.75

  # Since the update time depends mostly on the category items, we reflect that here:
  resources :categories, :priority => 0.75, :change_frequency => :daily, :updated_at => proc { |c| 
    (c.items.order('updated_at DESC').try(:first).try(:updated_at) || c.updated_at).strftime("%Y-%m-%d") }

  resources :items, :priority => 0.5
  resources :users, :skip_index => true, :priority => 0.25
end

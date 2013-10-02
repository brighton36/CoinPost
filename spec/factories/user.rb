FactoryGirl.define do
  factory :user do
    name 'Test User'
    email { 
      '%s@spectest.com' % [name.tr('^a-zA-Z0-9','').downcase]
    }
    
    password 'please'
    password_confirmation 'please'
    confirmed_at Time.now

    factory(:user_stewie){ name "Stewie Griffen" }

    factory(:user_ricon)   { name 'Rickon Stark' }
    factory(:user_rodrik)  { name 'Rodrik Cassel' }
    factory(:user_luwin)   { name 'Maester Luwin' }
    factory(:user_jory)    { name 'Jory Cassel' } 
    factory(:user_hodor)   { name 'Hodor' }
    factory(:user_mordane) { name 'Septa Mordane' } 
    factory(:user_jon)     { name 'Jon Umber' }
    factory(:user_roose)   { name 'Roose Bolton' } 
    factory(:user_rickard) { name 'Rickard Karstark' } 
    factory(:user_nan)     { name 'Old Nan' }
  
    factory :site_admin do
      name 'CoinPost Admin'
      email 'info@coinpost.com'
      password 'bUaxcGWjQH1yLGrju3pXbBLVDfmJkQ__'
      password_confirmation 'bUaxcGWjQH1yLGrju3pXbBLVDfmJkQ__'
      confirmed_at Time.now
    end
  end
end

module FactoryGirl
  def self.singleton_user(name)
    User.where(:email => build(name).email).first || create(name)
  end
  
  def self.seed_users
    [:site_admin, :user_ricon, :user_rodrik, :user_luwin,:user_jory,:user_hodor,
    :user_mordane, :user_jon, :user_roose, :user_rickard, :user_nan].collect{|p| 
      FactoryGirl.singleton_user p 
    }
  end
end


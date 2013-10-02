FactoryGirl.define do
  factory(:sp_after_sale, :class => :shipping_policy) { label 'Calculated after sale' }
  factory(:sp_price_incl, :class => :shipping_policy) { label 'Included in Price' }
  factory(:sp_see_desc,   :class => :shipping_policy) { label 'See Description' }
end

module FactoryGirl
  def self.singleton_shipping_policy(name)
    ShippingPolicy.where(:label => build(name).label).first || create(name)
  end

  def self.seed_shipping_policies
    [:sp_after_sale, :sp_price_incl, :sp_see_desc].collect{|p| 
      FactoryGirl.singleton_shipping_policy p 
    }
  end
end

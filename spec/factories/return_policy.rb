FactoryGirl.define do
  factory(:rp_replacements, :class => :return_policy) { label 'Replacements Only' }
  factory(:rp_full_refund, :class => :return_policy) { label 'Full Refund' }
  factory(:rp_see_description, :class => :return_policy) { label 'See Description' }
end

module FactoryGirl
  def self.singleton_return_policy(name)
    ReturnPolicy.where(:label => build(name).title).first || create(name)
  end

  def self.seed_return_policies
    [:rp_replacements, :rp_full_refund, :rp_see_description].collect{|p| 
      FactoryGirl.singleton_return_policy p 
    }
  end
end

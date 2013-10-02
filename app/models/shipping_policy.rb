class ShippingPolicy < ActiveRecord::Base
  validates_uniqueness_of :label

  attr_accessible :label

  def title; label; end
end

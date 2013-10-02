require Rails.root.join('lib','validates_unchangeable')
require Rails.root.join('lib','validates_bitcoin_address')

class Purchase < ActiveRecord::Base
  belongs_to :purchaser, :class_name => 'User'
  belongs_to :item
  
  validates :purchaser_id, :item_id, :quantity_purchased, :price_in_cents, 
    :btc_receive_address, :presence => true, :unchangeable => true

  %w(comment_on_purchaser comment_on_seller fulfillment_notes).each do |comment|
    validates comment.to_sym, :allow_nil => true, :allow_blank => true, :format => { 
      :message => :invalid_characters,
      :with => /\A[a-z0-9 \~\<\>\,\;\:\'\"\-\(\)\*\&\$\#\@\+\=_\.\\\/\!\?]+\z/i }
  end

  # NOTE: We're not validating the btc_address or price, since these attributes
  # should never be set directly, and merely copy from the item

  validates :quantity_purchased, :on => :create, 
    :numericality => { :greater_than => 0 }

  validate :item_quantity_available
  validate :item_is_purchaseable

  before_validation :local_attrs_from_item, :on => :create
  after_create  :create_item_memoizations
  after_destroy :destroy_item_memoizations
  
  after_initialize :set_default_values

  composed_of_money :price

  attr_accessible :purchaser, :item, :quantity_purchased

  scope :created_by, lambda { |for_user|
    order('purchases.created_at DESC').joins(:item).includes(:purchaser, :item => :creator).where(
      ['items.creator_id = ?', (for_user.kind_of? User) ? for_user.id : for_user] ) 
  }

  scope :purchased_by, lambda { |for_user|
    order('purchases.created_at DESC').includes(:purchaser, :item => :creator).where(
      ['purchases.purchaser_id = ?', (for_user.kind_of? User) ? for_user.id : for_user] ) 
  }

  scope :unfulfilled, lambda{ where 'item_sent_at IS NULL' }
  scope :fulfilled, lambda{ where 'item_sent_at IS NOT NULL' }
  scope :unpaid, lambda{ where 'payment_sent_at IS NULL AND item_sent_at IS NULL' }
  scope :paid, lambda{ where 'payment_sent_at IS NOT NULL OR item_sent_at IS NOT NULL' }

  scope :needs_feedback_from_purchaser, lambda{ |user| 
    purchased_by(user).where(:rating_on_seller => 0 ) }
  scope :needs_feedback_from_seller,   lambda{ |user|
    created_by(user).where(:rating_on_purchaser => 0) }

  scope :has_feedback_as_seller, lambda{ |user| 
    created_by(user).where(['rating_on_seller != ?', 0] ) }
  scope :has_feedback_as_purchaser,   lambda{ |user|
    purchased_by(user).where(['rating_on_purchaser != ?', 0]) }

  # This is mostly used for the dashboard count:
  # It's a little different than the needs_feedback* in that it counts "completed"
  # transactions, and not "all" transactions. So this only matches item_sent and 
  # payment_sent purchases
  scope :completed_needing_feedback_from, lambda{|user|
    order('purchases.created_at DESC').joins(:item).where( [
      '(%s) OR (%s)' % [
        [ 'items.creator_id = ?', 'purchases.item_sent_at IS NOT NULL', 
          'purchases.rating_on_purchaser = ?' ],
        [ 'purchases.purchaser_id = ?', 'purchases.rating_on_seller = ?',
          '(purchases.payment_sent_at IS NOT NULL OR purchases.item_sent_at IS NOT NULL )' ]
      ].collect{|c| c.join(' AND ')} ] + [user.id, 0]*2 )
  }

  # This is displayed on the user show
  scope :with_feedback_for, lambda{|user|
    order('purchases.created_at DESC').joins(:item).includes(:item).where( [
      '(%s) OR (%s)' % [
        [ 'items.creator_id = ?', 'purchases.rating_on_seller != ?'],
        [ 'purchases.purchaser_id = ?', 'purchases.rating_on_purchaser != ?']
      ].collect{|c| c.join(' AND ')} ] + [user.id, 0]*2 )
  }

  def total_in_cents
    price_in_cents * quantity_purchased
  end

  def total
    Money.new total_in_cents 
  end

  private

  def set_default_values(force = false)
    self.quantity_purchased = 1 if self.quantity_purchased.nil? || force
  end

  def item_is_purchaseable
    errors.add :item_id, :item_is_unpurchaseable if new_record? && item && !item.is_purchaseable
  end

  def item_quantity_available
    errors.add :quantity_purchased, :greater_than_quantity_availabile if ( new_record? &&
      item && quantity_purchased && (quantity_purchased > item.quantity_available) )
  end

  # Since item listings can change, we need to record some of the item fields 
  # into our purchase, so as to reflect the state of these fields at the time
  # of purchase. This method does this.
  def local_attrs_from_item
    if item
      write_attribute :btc_receive_address, item.send(:btc_receive_address) 
      write_attribute :price_in_cents, item.price.exchange_to('BTC').cents
    end
  end

  def create_item_memoizations
    item.increment_memoization :quantity_purchased, quantity_purchased
  end

  # This should never be called, but, I put in in here to preserve symmetry in
  # case we head towards new requirements in the future
  def destroy_item_memoizations
    item.increment_memoization :quantity_purchased, (quantity_purchased*-1) if item && !item.frozen?
  end
end

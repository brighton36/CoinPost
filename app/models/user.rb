require Rails.root.join('lib','validates_unchangeable')
require Rails.root.join('lib','validates_bitcoin_address')

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, 
    :rememberable, :trackable, :validatable, :confirmable

  has_many :items, :foreign_key => :creator_id

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  
  validates :name, :unchangeable => true

  validates :btc_receive_address, :bitcoin_address => true, 
    :if => Proc.new{|u| u.btc_receive_address.present? }

  validates :currency, :inclusion => { :in => ::MtgoxBank::SUPPORTED_CURRENCIES+[nil] }

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :confirmed_at, :location, :btc_receive_address, :currency

  # These scopes are for the user the message boxes, since messageable's threaded
  # view isn't going to cut my mustard (And are super inefficient)
  { :inbox   => [ 'inbox', false ], 
    :sentbox => [ 'sentbox', false ], 
    :trash   => [ 'inbox', true ]
  }.each_pair do |collection, conditions| 
    has_many ('messages_in_%s' % collection).to_sym,
      :source => :notification, 
      :include => [:sender, :receipts => :receiver],
      :through => :receipts,
      :order => 'notifications.created_at DESC',
      :conditions => ( [ [
        'notifications.type = ?', 
        'receipts.mailbox_type = ?',
        'receipts.trashed = ?'
      ].join(' AND '), 'Message']+conditions )
  end

  include FriendlyId
  friendly_id :name, :use => [:slugged]
  
  acts_as_messageable

  def role_symbols; [:registered_user]; end

  def mailboxer_email(object); email; end

  def feedback_as_seller
    feedback_counts :has_feedback_as_seller
  end

  def feedback_as_buyer
    feedback_counts :has_feedback_as_purchaser
  end
  
  def feedback
    feedback_counts :with_feedback_for
  end

  def self.site_admin
    where(:email => 'info@coinpost.com').first
  end

  private

  # NOTE: This method is only accurate so long as a person cannot buy their own
  # items.
  def feedback_counts(purchase_scope)
    collection = Purchase.send purchase_scope, self
    collection.inject({:total => 0, :positive => 0, :negative => 0}) do |ret, p|
      attr = (p.purchaser == self) ? :rating_on_purchaser : :rating_on_seller
      ret[:total] += 1
      case p.send(attr)
        when -1 then ret[:negative] += 1
        when 1 then ret[:positive] += 1
      end
      ret
    end
  end

end

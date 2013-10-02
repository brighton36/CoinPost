require Rails.root.join('lib','validates_unchangeable')
require Rails.root.join('lib','validates_bitcoin_address')
require Rails.root.join('lib','css_style_transformer')
require Rails.root.join('lib','slug_relocation_generator')

class Item < ActiveRecord::Base

  ONE_HOUR = 3600
  TWO_WEEKS = ONE_HOUR*24*14
  ONE_MONTH = ONE_HOUR*24*31

  MAXIMUM_IMAGE_COUNT = 6

  CSV_COLUMNS = %w(title location quantity_listed price_in_cents price_currency
    btc_receive_address lists_at expires_at categories description return_policy
    shipping_policy image1_url image2_url image3_url image4_url image5_url
    image6_url)

  belongs_to :creator, :class_name => 'User'
  belongs_to :shipping_policy
  belongs_to :return_policy
  has_and_belongs_to_many :categories
  has_many :images, :class_name => 'ItemImage'
  has_many :purchases

  with_options( :allow_nil => true, :format => { 
    :message => :invalid_characters,
    :with => /\A[a-z0-9 \~\<\>\,\;\:\'\"\-\(\)\*\&\$\#\@\+\=_\.\\\/\!\?]+\z/i
  } ) do |format|
    format.validates :title
    format.validates :location
  end

  validates :btc_receive_address, :bitcoin_address => true, :presence => true

  validates :creator, :description, :price_in_cents, :quantity_listed, 
    :expires_at, :lists_at, :slug, :title, :location,
    :presence => true

  validates :quantity_listed, :price, 
    :numericality => { :greater_than => 0 }
  
  validates :quantity_listed, 
    :numericality => { :greater_than_or_equal_to => :quantity_purchased }

  validates :categories, 
    :length => { :within => 1..3 , :message => :categories_within }

  validates :images, 
    :length => { :maximum => MAXIMUM_IMAGE_COUNT , :message => :length }

  # Cannot start more than an hour in the past, or a month in the future:
  validates :lists_at, :on => :create,
    :date => {
      :after_or_equal_to  => Proc.new { Time.now.utc-ONE_HOUR }, 
      :message => :in_past
    }
  validates :lists_at, :on => :create,
    :date => {
      :before_or_equal_to => Proc.new { Time.now.utc+ONE_MONTH }, 
      :message => :more_than_one_month
    }
  
  # Expiration must occur after the lists_at
  validates :expires_at, :on => :create, 
    :date => { :after => :lists_at, :message => :after_lists_at }
 
  # Listing cannot last more than a month
  validates_each :expires_at do |record, attr, value|
    record.errors.add(
      attr, :max_hours
    ) if record.expires_at.to_i - record.lists_at.to_i > ONE_MONTH
  end

  validates :lists_at, :expires_at, :creator_id, :unchangeable => true

  validates :price_currency, 
    :inclusion => { :in => ::MtgoxBank::SUPPORTED_CURRENCIES+%w(BTC) }

  composed_of_money :price, true

  attr_accessible :title, :location, :shipping_policy_id, :return_policy_id, 
    :category_ids, :description, :price_in_cents,:price_currency, :quantity_listed, 
    :expires_at_date, :expires_at_time, :lists_at_date, :lists_at_time,
    :btc_receive_address, :price_in_btc, :price_in_currency


  after_initialize :set_default_values

  scope :purchaseable, lambda {
    now = Time.now.utc

    where( [
      [ 'items.expires_at > ?', 'items.lists_at <= ?', 'items.enabled = ?', 
        'items.quantity_listed > items.quantity_purchased'
      ].join(' AND '),
      now, now, true
    ])
  }
  
  scope :unpurchaseable, lambda {
    now = Time.now.utc

    where( [
      [ 'items.expires_at <= ?', 'items.lists_at > ?', 'items.enabled = ?', 
        'items.quantity_listed <= items.quantity_purchased'
      ].join(' OR '),
      now, now, false
    ])
  }
  
  scope :expired, lambda {
    where([ 'expires_at < ?', Time.now.utc ]).order('expires_at ASC')
  }
  
  scope :pending, lambda {
    where([ 'lists_at >= ?', Time.now.utc ]).order('expires_at ASC')
  }

  scope :current_or_pending, lambda {
    where([ 'expires_at > ?', Time.now.utc ]).order('expires_at ASC')
  }

  scope :not_pending, lambda {
    where([ 'lists_at < ?', Time.now.utc ]).order('expires_at ASC')
  }

  scope :created_by, lambda { |user|
    where(:creator_id => (user.kind_of? User) ? user.id : user )
  }

  scope :purchaseable_in_categories, lambda { |category_ids|
    purchaseable.joins(:categories).where(
      'categories_items.category_id IN (?)',    
      [category_ids].flatten.collect{|c| (c.kind_of? Category) ? c.id : c }
    )
  }

  include FriendlyId
  friendly_id :uniqued_username_and_title, :use => [:slugged], 
    :slug_generator_class => SlugRelocationGenerator

  sanitize_on_assignment :description, :remove_contents => true,
    :elements   => %w( p strong em span a h2 h3 h4 h5 h6 pre blockquote ul ol 
      li img table caption tbody tr td),
    :attributes => {
      'a'     => %w(href title),
      'img'   => %w(src alt width height),
      'table' => %w(border cellspacing cellpadding align),
      'td'    => %w(colspan width),
      :all    => ['style']
    },
    :protocols  => {
      'a'   => {'href' => ['http', 'https', 'mailto']},
      'img' => {'src' => ['http', 'https']}
    },
    :add_attributes => {'a' => {'rel' => 'nofollow'}},
    :transformers => [ CssStyleTransformer.new(
      'text-decoration'  => /\Aunderline\Z/,
      'color'            => :color_rgb,
      'background-color' => :color_rgb,
      'text-align'       => :left_center_right, 
      'float'            => :left_right,
      'padding-left'     => :single_dim,
      'height'           => :single_dim,
      'width'            => :single_dim
    ) ]

  def listing_teaser
    ActionController::Base.helpers.strip_tags(read_attribute(:description))[0..200]
  end

  def category_listing_thumbnail
    %w(images first image category_listing_small).inject(self) do |ret, attr|
      ret.try attr.to_sym
    end
  end

  def quantity_purchased
    purchases.sum(:quantity_purchased)
  end

  def has_sales
    quantity_purchased > 0
  end

  def quantity_available
    quantity_listed - quantity_purchased
  end

  def is_expired
    expires_at <= Time.now.utc
  end
  
  def is_pending
    lists_at > Time.now.utc
  end

  def is_purchaseable
    now = Time.now.utc
    enabled && (expires_at > now) && (lists_at <= now) && 
      (quantity_purchased < quantity_listed) 
  end

  def is_unpurchaseable
    now = Time.now.utc
    (!enabled) || (expires_at <= now) || (lists_at > now) || 
      (quantity_purchased >= quantity_listed) 
  end

  # This is used by the slug_relocation_generator. If we're a purchaseable item, 
  # then we return false. Else, we're able to relocate.
  alias :is_slug_relocateable? :is_unpurchaseable 

  # This creates multiparameter time setters compatible with our controller
  [:expires_at,:lists_at].each do |ar_attr|
    %w(date time).each do |attr_suffix|
      attr = [ar_attr,attr_suffix].join('_')
      
      attr_reader attr

      define_method('%s=' % attr) do |val| 
        instance_variable_set ('@%s' % attr), val
        self.send('set_%s_by_text' % attr_suffix, ar_attr, val)
      end
    end
  end

  def set_default_values(force = false)
    self.quantity_listed = 1 if self.quantity_listed.nil? || force
    self.lists_at = Time.now.utc if self.lists_at.nil? || force
    self.expires_at = lists_at + ONE_MONTH if self.expires_at.nil? || force
    self.enabled = true if force

    # If we're runnig a query that doesn't select for these attributes, we'll
    # get an error as the default tries to set. This fixes that
    rescue ActiveModel::MissingAttributeError
  end

  def increment_memoization(attr, amnt)
    write_attribute attr, (read_attribute(attr) + amnt)
    save!
  end

  def price_in_btc=(amnt)
    self.price = Money.from_string amnt, 'BTC'
  end

  # This is mostly used by the item create form:
  def price_in_currency=(parts)
    self.price = Money.from_string parts[:price], parts[:currency]
  end

  def uniqued_username_and_title
    [creator.try(:name), title]
  end

  def normalize_friendly_id(value)
    value.compact.collect{|v| v.to_s.parameterize }.join('/')
  end

  def to_csv
    CSV_COLUMNS.collect do |attr| 
      value = self.send(attr) if self.respond_to? attr

      if attr == 'categories'
        # This is basically to deal with the categories
        value.collect(&:to_param).join(',')
      elsif attr == 'shipping_policy' or attr == 'return_policy'
        value.try(:label)
      elsif value.kind_of? Time
        value.to_time.iso8601 
      else
       value 
      end
    end
  end
  
  # This is a shortcut helper for the to_csv method
  1.upto(MAXIMUM_IMAGE_COUNT) do |i|
    define_method('image%d_url' % i){ images[i-1].image.url if images.count >= i }
  end

  private

  def set_date_by_text(attr, input)
    if /\A([\d]+)[\/]?([\d]*)[\/]?([\d]*)/.match(input.strip)
      now = Time.now.in_time_zone
      parts = {:month => $1, :day => $2, :year => $3}
      parts.delete_if{|k,v| v.empty?}
      parts = Hash[parts.collect{|k,v| [k, v.to_i]}]

      # Depending on the number of digits in year, we construct the full year
      parts[:year] = case (Math.log10(parts[:year]).floor+1)
        when 1, 2 then now.year / 100 * 100 + parts[:year]
        when 3    then now.year / 1000 * 1000 + parts[:year]
        else parts[:year]
      end if parts.key? :year

      parts[:day] ||= 1

      write_attribute attr,
        (self.send(attr) || now).change(parts)
    end
  end

  def set_time_by_text(attr, input)
    if /\A([\d]+)[\:]?([\d]*)(?:[ ]*(A|P)[M]?|)/.match(input.strip.upcase)
      hour,min,meridian = $1.to_i, $2.to_i, $3
      hour += 12 if meridian.try(:==, 'P') && hour.try(:<, 12)

      write_attribute attr,
        (self.send(attr) || Time.now.in_time_zone).change(:hour => hour, :min => min)
    end
  end
end

ActiveRecord::Base.class_eval do
  def self.composed_of_money(attr, store_currency = false)
    mapping = [ ['%s_in_cents' % attr, 'cents'] ]
    mapping << [ '%s_currency' % attr, 'currency_as_string' ] if store_currency

    composed_of attr, 
      :class_name  => 'Money', :mapping => mapping,
      :constructor => Proc.new { |cents, currency| 
        Money.new(cents || 0, currency || Money.default_currency)
      },
      :converter => Proc.new { |value| 
        value.respond_to?(:to_money) ? 
          value.to_money : 
          raise(ArgumentError, "Can't convert %s to Money" % value.class) 
      }
  end
end

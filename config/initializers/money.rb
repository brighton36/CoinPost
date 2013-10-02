require 'money'
require 'mtgox_bank'

Money::Currency.register({
  :priority        => 1,
  :iso_code        => "BTC",
  :name            => "Bitcoin",
  :symbol          => "BTC",
  :subunit         => "Cent",
  :subunit_to_unit => 100000000,
  :separator       => ".",
  :delimiter       => ","
})

Money.default_currency = Money::Currency.new :btc
Money.default_bank = MtgoxBank.new

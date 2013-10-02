require 'money'
require 'mtgox'

class MtgoxBank < Money::Bank::VariableExchange
  CACHE_EXPIRATION = 15.minutes

  SUPPORTED_CURRENCIES = %w(USD EUR GBP AUD CAD CHF CNY DKK HKD JPY NZD PLN RUB SEK SGD THB)

  # We define this here so that we can run tests on the Exchange rates without
  # having to worry about whatever the actual exchange rate might be
  cattr_accessor :ticker_rates

  # Seemingly, floats are what the VariableExchange wants to have returned
  # these are then cast to strings and fed to BigDecimal before being applied
  # to exchange translations. (Returning strings or BigDecimals will work too) 
  def get_rate(from, to)
    @mutex.synchronize do
      case rate_key_for(from, to)
        when /\A(#{SUPPORTED_CURRENCIES.join('|')})_TO_BTC\Z/
          ( BigDecimal(1) / BigDecimal(ticker($1).to_s) ).to_s
        when /\ABTC_TO_(#{SUPPORTED_CURRENCIES.join('|')})\Z/
          ticker $1
        else
          # This means we're converting between the exchange currencies, using
          # btc as the intermediary
          (ticker(to) / ticker(from)).to_s
      end 
    end
  end

  # If we're converting to BTC, we want to round our irrational numbers to 
  # something more reasonable. The definition of 'reasonable' is tied to the
  # number of digits in the exchange rate.
  def exchange_with(from, to_currency)
    ret = super from, to_currency

    if to_currency.symbol == 'BTC'
      # We need to round based on the strength of the source currency
      # But many times our source currency is simply btc. So, let's use USD then:
      using_currency = (from.currency.iso_code == 'BTC') ? 'USD' : from.currency.iso_code

      # This determines the number of decimal digits in the ticker 
      ticker_digits = Math.log10(ticker(using_currency)).floor

      # When we're totally in the decimal digits, we don't need to round
      ticker_digits = -3 if ticker_digits < -3

      by_mod = 10 ** (5 - ticker_digits)
      return Money.new(ret.cents - (ret.cents % by_mod), 'BTC')
    end 

    ret
  end

  private 

  def ticker(for_cur)
    for_cur = for_cur.to_s.downcase
    (self.class.ticker_rates.try(:[],for_cur)) ? 
      self.class.ticker_rates[for_cur] :
      Rails.cache.fetch('mtgox/ticker/%s' % for_cur, :expires_in => CACHE_EXPIRATION){
        Rails.logger.info "MtgoxBank is querying for %s" % for_cur
        begin
          MtGox.ticker(for_cur.to_sym).last
        rescue Errno::ETIMEDOUT, Errno::ECONNRESET, Faraday::Error::TimeoutError
          # Note/TODO: MtGox is down
        end
      }
  end
end

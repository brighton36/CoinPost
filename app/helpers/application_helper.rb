require Rails.root.join('lib','formtastic_datetime_input')
require Rails.root.join('lib','nav_link')

module ApplicationHelper
  def page_title(key = 'title')
    t_params = title_params if respond_to? :title_params
    t_params ||= {}

    t [controller_name, action_name, key].join('.'),
      t_params.merge({:raise => true})

  rescue I18n::MissingTranslationData
    nil
  end

  def page_header_title
    use_title = page_title('header_title') || page_title 
    use_title ? '%s | CoinPost' % use_title : t('layouts.application.tagline')
  end

  def btc_money(amount)
    raw('<span class="%s">%s<span class="%s">%s</span></span>' % [ 
      'btc_money', image_tag('btc-symbol-16.gif', :size => '11x16'),
      'amount', btc_money_delimit(amount)
    ]) unless amount.nil?
  end

  def btc_money_delimit(amnt)
    number_with_delimiter( 
      # This removes trailing 0's:
      ( (/(.+?\.[0]?.*?)[0]*$/.match amnt.exchange_to('BTC').to_s) ? $1 : amnt ), 
      :delimiter => ',', :precision => 16 )
  end
  
  def money_in_user_currency(amnt)
    link_to "About %s %s" % [amnt.exchange_to(user_currency).format, user_currency], 
      '#', :rel => 'tooltip', 'data-placement' => 'right',
      'data-original-title' => "Conversion rate is calculated using Mt.Gox's sell ticker, approximately once every 15 minutes"

  end

  def header_navigation
    ret = [
      [:index, root_path ],
      [:buy,  categories_path],
      [:sell, new_item_path, 
        permitted_to?(:create, Item.new) ? :nil : 'toggle_auth_required'],
        [:get_coins, get_coins_path],
        [:about_us,  about_us_path],
        [:help, help_path]
    ].collect{|args| NavLink.new(*args)}

    @active_header_label = respond_to?(:active_header) ? active_header : :home

    ret.find{|nl| nl.label == @active_header_label}.try(:active=, true)

    ret
  end

  def user_currency
    ((current_user) ? current_user.try(:currency) : session[:user_currency]) || 'USD'
  end

  def currency_option_label(iso_code)
    '%s (%s)' % [ iso_code, currency_symbol(iso_code) ]
  end

  def currency_symbol(iso_code)
    cur = Money::Currency.find iso_code.downcase.to_sym
    (cur.html_entity.empty?) ? cur.symbol : cur.html_entity
  end

  def supported_currencies
    ::MtgoxBank::SUPPORTED_CURRENCIES
  end

  def supported_currencies_options_map
    supported_currencies.map{ |iso_code| 
      [ currency_option_label(iso_code), iso_code ] }
  end

  def blocks_for(position)
    params_helper = ['block_params', position].join('_')
    (respond_to? params_helper) ? self.send(params_helper) : nil
  end

  def tinymce_minimal(opts = {})
    tinymce( {
      :theme_advanced_buttons1 => "bold,italic,underline,forecolor,separator,justifyleft,justifycenter,justifyright,separator,formatselect,separator,bullist,numlist,separator,outdent,indent,separator,link,unlink,separator,charmap,separator,code",
      :theme_advanced_buttons2 => "",
      :theme_advanced_blockformats => "p,h3,h4,h5,h6,blockquote,pre"
    }.merge(opts) )
  end

  def btc_to_currency_header
    raw ( '%s1.0 BTC = %s' % [ 
      image_tag('btc-symbol-blue-16.gif', :size => '11x16'),
      Money.new(100000000,'BTC').exchange_to(user_currency).format ] )
  end

  # Carrierwave image tag. We use this method so that the dimensions get automatically
  # assigned
  def cw_image(uploader, opts)
    opts[:size] ||= [uploader.width, uploader.height].join('x')
    image_tag uploader, opts
  end
end

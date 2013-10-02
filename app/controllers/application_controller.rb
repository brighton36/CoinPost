class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_user_time_zone

  before_filter :set_current_user

  before_filter :set_user_currency

  protected

  def set_current_user
    Authorization.current_user = current_user
  end

  def permission_denied
    respond_to do |format|
      format.html do
        flash[:error] = t( 'devise.failure.%s' % [
          (current_user) ? 'unauthorized' : 'unauthenticated'
        ] )

        redirect_to(:back) rescue redirect_to('/') 
      end

      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
      format.json { head :unauthorized }
    end
  end

  def after_sign_in_path_for(resource)
    dashboard_index_url
  end

  # We maintain both a js-detected tz, as well as a user-selected tz
  # If the user selects a tz, it stays active until either the detected_tz
  # or the user selection changes
  def set_user_time_zone
    detected_tz = cookies[:tz_offset] || 'Etc/UTC'

    if detected_tz && ( session[:detected_tz] != detected_tz )
      session[:detected_tz] = detected_tz
      session[:user_tz] = nil
    end

    session[:user_tz] = params[:user_tz] if params[:user_tz]
  
    Time.zone = ActiveSupport::TimeZone[
      session[:user_tz] || session[:detected_tz] || 'Etc/UTC'
    ]
  end

  def set_user_currency
    if ( params.has_key?(:user_currency) &&  
      ::MtgoxBank::SUPPORTED_CURRENCIES.include?(params[:user_currency]) )

      if current_user
        current_user.currency = params[:user_currency]
        current_user.save!
      else
        session[:user_currency] = params[:user_currency]
      end 
    end 
  end
end

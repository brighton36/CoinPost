class RegistrationsController < Devise::RegistrationsController

  # We overide the default devise behavior only because we don't want the user to
  # have to know his current password, in order to change his password
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_attributes(resource_params.tap{|rp| 
      pw_attrs = %w(password password_confirmation)
      rp.reject!{|k,v| pw_attrs.include? k.to_s } if pw_attrs.all?{|a| rp[a.to_sym].empty?}
    })
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => dashboard_index_path
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def create
    @passed_captcha = verify_recaptcha

    # The recaptcha flash implementation is stupid with the flash so we clear
    # it here:
    flash.clear

    build_resource

    # We assign their choosen currency to their profile, if one exists:
    resource.currency = session[:user_currency] if session.has_key? :user_currency

    if resource.valid? && @passed_captcha
      resource.save

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource

      respond_with resource do |format| 
        format.html do
          flash[:error] = t('registrations.create.captcha_error') unless @passed_captcha
          render
        end
        format.js do
          errors = resource.errors.to_hash
          errors[:captcha] = [t('registrations.create.captcha_error')] unless @passed_captcha
        
          render :json => {:errors => errors }, :status => 422
        end
      end
    end
  end


end

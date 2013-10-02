module RegistrationsHelper
  def title_params
    {:user => @user.name } if @user
  end

  def active_header; :dashboard; end

  def block_params_left
    ret = []
    ret << [:cell, :dashboard, :show, :user => current_user] if (
      /\A(?:edit|update)\Z/.match(action_name) )
  end
end

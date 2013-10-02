module DashboardHelper
  def active_header; :dashboard; end

  def block_params_left
    [ [:cell, :dashboard, :show, :user => current_user] ]
  end
end

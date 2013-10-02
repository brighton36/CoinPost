class DashboardCell < Cell::Rails

  # I'm not entirely sure why this needed, but seemingly, changes to this file 
  # in dev mode, removes our overrides on the mailboxer engine.
  require_dependency 'app/engine_overrides/mailboxer' if Rails.env.development?

  def show(opts = {})
    @user = opts[:user]
    @message_count = @user.messages_in_inbox.unread.count
    @unpaid_purchases_count = Purchase.purchased_by(@user).unpaid.count
    @unfulfilled_orders_count = Purchase.created_by(@user).unfulfilled.count
    @needs_feedback_count = Purchase.completed_needing_feedback_from(@user).count

    @controller_name = params[:controller]
    @action_name = params[:action]
    render
  end
end

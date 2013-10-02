class ItemCell < Cell::Rails
  helper :application
  helper TinyMCE::Rails::Helper
  prepend_view_path 'app/views'

  # I'm not entirely sure why this needed, but seemingly, changes to this file 
  # in dev mode, removes our overrides on the mailboxer engine.
  require_dependency 'app/engine_overrides/mailboxer' if Rails.env.development?

  def show(opts = {})
    @item = opts[:item]
    @user = opts[:current_user]

    if @user
      @purchase = @item.purchases.build :purchaser => @user if @item.is_purchaseable

      @message = Message.new 
    end

    render
  end
end

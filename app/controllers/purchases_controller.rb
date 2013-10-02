class PurchasesController < ApplicationController
  filter_access_to :unfulfilled, :fulfilled, :unpaid, :paid, :needs_feedback,
    :attribute_check => true, :load_method => :user_from_params
  filter_access_to :mark_paid, :mark_fulfilled, :attribute_check => true,
    :load_method => :user_with_purchase_from_params
  filter_access_to :create, :attribute_check => true, 
    :load_method => lambda { |c| 
      @item = Item.find params[:id], :include => :creator
      raise ::Authorization::AttributeAuthorizationError if current_user == @item.creator
      @item
    }
  filter_access_to :leave_feedback, :attribute_check => true, 
    :load_method => lambda {|c| 
      user_with_purchase_from_params
      
      raise ::Authorization::AttributeAuthorizationError unless(
        ( 
          # They're the seller, leaving feedback on the Purchaser:
          @purchase.item.creator == @user && 
          params[:purchase].keys.all?{|k| k.match /on_purchaser\Z/ } 
        ) || ( 
          # They're the buyer, leaving feedback on the Seller:
          @purchase.purchaser == @user && 
          params[:purchase].keys.all?{|k| k.match /on_seller\Z/ } 
        )
      )

      @purchase
    }
  filter_access_to :all

  respond_to :json, :only => :create
  
  JSON_ACTIONS = [:create, :leave_feedback, :mark_fulfilled]

  respond_to :html, :except => JSON_ACTIONS
  respond_to :json, :only   => JSON_ACTIONS

  def index
    purchases = Purchase.send(
      /\A(?:un|)paid\Z/.match(action_name) ? :purchased_by : :created_by, @user
    ).send(action_name.to_sym)
    @purchases_count = purchases.count
    @purchases = purchases.page params[:page]
    respond_with(@purchases){ |format| format.html{ render } }
  end

  %w(unfulfilled fulfilled unpaid paid).each{ |m| alias_method m.to_sym, :index }

  def needs_feedback
    @purchases = {
      :by_user   => Purchase.needs_feedback_from_purchaser(@user),
      :by_others => Purchase.needs_feedback_from_seller(@user)
    }
    
    respond_with(@purchases){ |format| format.html{ render } }
  end

  def create
    @purchase = @item.purchases.build( :purchaser => current_user,
      :quantity_purchased => params[:purchase][:quantity_purchased] )

    respond_with @purchase do |format|
      # This needs to be in a transaction, so that we don't have problems with the 
      # purchases counter cache becoming invalid due to multiple people trying 
      # to purchase around the same time.
      if Item.transaction{ @purchase.save }
        # Now we notify the parties involved:
        {
        :message_to_creator   => {:recipients => [@item.creator], :sender => current_user},
        :message_to_purchaser => {:recipients => [current_user], :sender => @item.creator}
        }.each_pair do |dest, msg_opts|
          subject, body = %w(subject body).collect{|part|
            t('purchases.create.%s_%s' % [dest, part], {
              :title => @item.title, :price => @purchase.total, 
              :btc_receive_address => @item.btc_receive_address,
              :purchaser => current_user.name, :creator => @item.creator.name,
              :item_url => item_path(@item, :only_path => false),
              :purchaser_url => user_path(current_user, :only_path => false), 
              :creator_url => user_path(@item.creator, :only_path => false)
            } )
          }
          Message.new( msg_opts.merge({ :body => RDiscount.new(body).to_html, 
            :subject => subject,
            :conversation => Conversation.new(:subject => subject) })
          ).deliver false, false # is_reply, should_clean
        end

        format.json { render :json => { :total_in_cents => @purchase.total_in_cents.to_s } }
      else
        format.json do
          render :json => {:errors => @purchase.errors}, :status => 422
        end
      end
    end
  end

  def mark_fulfilled
    @purchase.item_sent_at = Time.now.utc
    @purchase.fulfillment_notes = params.try(:[],:purchase).try(:[],:fulfillment_notes)
    
    respond_to do |format|
      if @purchase.save
        # Now we notify the purchaser of their fulfillment:
        subject, body = %w(subject body).collect{|part|
          t('purchases.mark_fulfilled.message_to_purchaser_%s' % [part], {
            :fulfillment_notes => @purchase.fulfillment_notes,
            :title => @purchase.item.title, 
            :price => @purchase.total, 
            :purchaser => current_user.name, 
            :creator => @purchase.item.creator.name,
            :item_url => item_path(@purchase.item, :only_path => false),
            :purchaser_url => user_path(current_user, :only_path => false), 
            :creator_url => user_path(@purchase.item.creator, :only_path => false)
          } )
        }
        Message.new( :body => RDiscount.new(body).to_html, 
          :recipients => [@purchase.purchaser], 
          :sender => @purchase.item.creator,
          :subject => subject,
          :conversation => Conversation.new(:subject => subject) 
        ).deliver false, false # is_reply, should_clean

        format.json { render :json => true }
      else
        format.json{ render :json => {:errors => @purchase.errors}, :status => 422 }
      end
    end
  end
  
  def mark_paid
    @purchase.payment_sent_at = Time.now.utc
    
    respond_to do |format|
      if @purchase.save
        flash[:notice] = t('flash.messages.mark_paid.notice')
      else
        flash[:error] = t('flash.messages.mark_paid.alert')
      end
      format.html { redirect_to purchases_unpaid_users_path(@user) }
    end
  end

  def leave_feedback
    feedback_for = ( @purchase.purchaser == @purchase.item.creator ) ?
      ( (params[:purchase].key? :rating_on_seller) ? :on_seller : :on_purchaser ) :
      ( ( @purchase.purchaser == @user ) ? :on_seller : :on_purchaser )

    %w(comment rating).collect{|f| [f,feedback_for].join('_') }.each do |f|
      @purchase.send '%s=' % f, params[:purchase][f] if params[:purchase].key? f
    end

    rating_field = ('rating_%s' % feedback_for).to_sym

    errors = { rating_field => [ t(
      'activerecord.errors.models.purchase.attributes.%s.required' % rating_field
    ) ] } unless @purchase.send(rating_field) != 0
    
    respond_to do |format|
      if errors.nil? && @purchase.save
        format.json { render :json => true }
      else
        format.json{ render :json => { 
          :errors => (errors) ? errors : @purchase.errors }, :status => 422 }
      end
    end
  end

  private

  def user_from_params  
    @user = User.find params[:user_id] 
  end

  def user_with_purchase_from_params
    user_from_params
    raise ::Authorization::AttributeAuthorizationError unless @user == current_user

    @purchase = Purchase.find params[:id]
  end
end

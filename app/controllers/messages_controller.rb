class MessagesController < ApplicationController
  # I'm not entirely sure why this needed, but seemingly, changes to this file 
  # in dev mode, removes our overrides on the mailboxer engine.
  require_dependency 'app/engine_overrides/mailboxer' if Rails.env.development?

  [ [ :inbox, :sentbox, :trash, :create, :attribute_check => true, 
      :load_method => lambda { |c| @user = User.find params[:user_id] } ],
    [ :show, :reply, :create_reply, :attribute_check => true,
      :load_method => lambda {|c| 
        @user = User.find params[:user_id]
        raise ::Authorization::AttributeAuthorizationError unless @user == current_user

        @message = Message.find params[:id]
    } ],
    [ :trash_messages, :untrash_messages, :attribute_check => true, 
      :load_method => lambda {|c| 
        @user = User.find params[:user_id]
        raise ::Authorization::AttributeAuthorizationError unless @user == current_user

        @messages = Message.where(['id IN (?)',params[:message_ids]]).all
       
        raise ::Authorization::AttributeAuthorizationError unless (
          @messages.to_a.all?{|msg| msg.recipients.to_a.include?(@user)} )
      } ],
    [ :create_from_item, :attribute_check => true, :model => Item],
    [:all] 
  ].each{|args| filter_access_to *args }

  JSON_ACTIONS = [:create, :create_from_item]

  respond_to :html, :except => JSON_ACTIONS
  respond_to :json, :only   => JSON_ACTIONS

  def index
    messages = @user.send('messages_in_%s' % action_name)
    @message_count = messages.count
    @messages = messages.page params[:page]
    respond_with(@messages){ |format| format.html{ render } }
  end
  
  %w(inbox sentbox trash).each{ |m| alias_method m.to_sym, :index }

  def show
    current_user.read @message
    respond_with(@message){ |format| format.html{ render } }
  end

  def reply
    current_user.read @message

    @reply = Message.new :conversation_id => @message.conversation_id, 
      :subject => ('RE: %s' % @message.subject)

    respond_with(@reply){ |format| format.html{ render } }
  end

  def create_reply
    recipients = @message.recipients.uniq.reject{|u|u == current_user}

    @reply = new_message recipients, nil, 
      Conversation.find(@message.conversation_id)
    
    respond_with @reply do |format|
      if @reply.valid?
        @reply.deliver true, false # is_reply, should_clean

        flash[:notice] = t('flash.messages.reply.notice')
        format.html { redirect_to messages_inbox_users_url(current_user) }
      else
        flash[:error] = t('flash.messages.reply.alert')
        format.html { render :action => :reply }
      end
    end
  end

  def create
    @message = (action_name == 'create_from_item') ?
      new_message(@item.creator, 'Question for Item %s' % @item.title) : 
      new_message(@user)

    respond_with @message do |format|
      if @message.valid?
        @message.deliver false, false # is_reply, should_clean
        format.json { render :json => true }
      else
        format.json do
          render :json => {:errors => @message.errors}, :status => 422
        end
      end
    end
  end

  alias_method :create_from_item, :create

  # Despite the method name, note that this handles the untrash action as well
  def trash_messages
    conv_action = (action_name == 'trash_messages') ? :trash : :untrash

    @messages.each{ |conv| current_user.send conv_action,  conv }

    respond_with @messages do |format|
      flash[:notice] = t('flash.messages.%s_messages.notice' % conv_action.to_s)
      
      format.html do
        redirect_to (conv_action == :trash) ? 
          messages_inbox_users_url(current_user) :
          messages_trash_users_url(current_user)
      end
    end
  end
  
  alias_method :untrash_messages, :trash_messages

  private

  def new_message(recipients, subject = nil, conversation = nil)
    subject ||= params[:message][:subject]
    conversation ||= Conversation.new :subject => subject

    Message.new :sender => current_user,
      :body         => params[:message][:body],
      :subject      => subject,
      :conversation => conversation,
      :recipients   => (recipients.kind_of? Array) ? recipients : [recipients]
  end
end

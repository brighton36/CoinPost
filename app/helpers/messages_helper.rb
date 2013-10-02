module MessagesHelper
  def active_header; :dashboard; end

  def block_params_left
    [ [:cell, :dashboard, :show, :user => current_user] ]
  end

  def title_params
    {:subject => @message.subject } if @message
  end
    
  def resource_assets
    [tinymce_assets] if %w( reply send_reply ).include? action_name
  end

  def link_to_message_folder(msg, t_key = nil)
    folder, url = nil, nil
    if msg.sender == current_user
      folder, url = 'Sent Items', messages_sentbox_users_path(current_user)
    else
      if msg.is_trashed? current_user
        folder, url = 'Trashed Messages', messages_trash_users_path(current_user)
      else
        # Inbox
        folder, url = 'Inbox', messages_inbox_users_path(current_user)
      end
    end

    link_to (t_key) ? t(t_key, :folder_name => folder) : folder, url
  end

end

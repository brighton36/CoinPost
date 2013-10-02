require Rails.root.join('lib','css_style_transformer')
require Rails.root.join('config','initializers', 'sanitize_on_assignment')

Conversation.class_eval do
  # Fix for config.active_record.whitelist_attributes
  attr_accessible :subject, :message
end

Message.class_eval do
  validates :subject, :format => { :message => :invalid_characters,
    :with => /\A[a-z0-9 \~\<\>\,\;\:\'\"\-\(\)\*\&\$\#\@\+\=_\.\\\/\!\?]+\z/i},
    :allow_blank => true

  # Fix for config.active_record.whitelist_attributes
  attr_accessible :sender, :conversation, :body, :subject, :attachment, 
    :conversation_id, :recipients
  
  sanitize_on_assignment :body, :remove_contents => true,
    :elements => %w( 
      p strong em span a h3 h4 h5 h6 pre blockquote ul ol li caption),
    :attributes   => { 'a' => %w(href title), :all => ['style'] },
    :protocols    => { 'a' => {'href' => ['http', 'https', 'mailto']} },
    :transformers => [ CssStyleTransformer.new(
      'text-decoration' => /\Aunderline\Z/,
      'color'           => :color_rgb,
      'text-align'      => :left_center_right, 
      'float'           => :left_right,
      'padding-left'    => :single_dim,
      'height'          => :single_dim,
      'width'           => :single_dim
    ) ]

end

Notification.class_eval do
  # We had to redefine this since the original version was retuning unread message 
  # counts that were twice what they should be due to extra joining
  scope :unread, lambda{
    where('receipts.read = ?', false)
  }
end

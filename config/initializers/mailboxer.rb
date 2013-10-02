Mailboxer.setup do |config|
  
  #Configures if you applications uses or no the email sending for Notifications and Messages
  config.uses_emails = (!Rails.env.test?)
  
  #Configures the default from for the email sent for Messages and Notifications of Mailboxer
  config.default_from = "coinpost.com <info@coinpost.com>"
  
  #Configures the methods needed by mailboxer
  config.email_method = :mailboxer_email
  config.name_method = :name

  #Configures if you use or not a search engine and wich one are you using
  #Supported enignes: [:solr,:sphinx] 
  config.search_enabled = false
  config.search_engine = :solr
end

require Rails.root.join('app','engine_overrides','mailboxer')

class ContactMailer < ActionMailer::Base
  default from: "info@coinpost.com"

  def contact_us(email, subject, message, user_agent, user_address)
    @subject, @email, @message = subject, email, message
    @user_agent, @user_address = user_agent, user_address
    mail :to => 'info@coinpost.com', :subject => 'CoinPost Help "%s"' % [@subject]
  end
end

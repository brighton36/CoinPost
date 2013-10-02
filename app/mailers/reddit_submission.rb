class RedditSubmission < ActionMailer::Base
  default from: "info@coinpost.com", to: "info@coinpost.com"

  def activity(user, item, reddit_username, login_response, reddit_response)
    @user, @item, @reddit_username, @login_response, @reddit_response = user, 
      item, reddit_username, login_response, reddit_response

    mail :subject => "CP Reddit Submission by: %s" % user.name
  end

  def fail(user, item, message)
    @user, @item, @error_message = user, item, message
    mail :subject => "CP Reddit Submission Fail by: %s" % user.name
  end
end

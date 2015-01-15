module PasswordRecoveryHelpers

  def send_email_to user, email
    api_key = ENV['MAILGUN_API_KEY']
    api_url = "https://api:#{api_key}@api.mailgun.net/v2/app33254319.mailgun.org"
    
    RestClient.post api_url + "/messages",
        :from    => "postmaster@app33254319.mailgun.org",
        :to      => user.email,
        :subject => email[:subject],
        :text    => email[:message]
  end

end
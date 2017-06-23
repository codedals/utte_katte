class TwitterAccount < LinkedAccount

  def tweet(message)
    Twitter.configure do |config|
      config.consumer_key = TWITTER_CONSUMER_KEY
      config.consumer_secret = TWITTER_CONSUMER_SECRET
      config.oauth_token = self.token
      config.oauth_token_secret = self.secret
    end
    
    client = Twitter::Client.new
    client.update(message)
  end

end

UtteKatte::Application.config.middleware.use OmniAuth::Builder do
 #require 'openid/store/filesystem' 
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
  provider :facebook, FACEBOOK_KEY, FACEBOOK_SECRET, :scope => 'email, publish_stream'#, :setup => true
  provider :soundcloud, SOUNDCLOUD_KEY, SOUNDCLOUD_SECRET
  provider :google_oauth2, GOOGLE_KEY, GOOGLE_SECRET, {access_type: 'online', approval_prompt: ''}
  
 #provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
end


#FOR PRODUCTION NEED TO SET  {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}} in provider for facebook
# SEE http://stackoverflow.com/questions/3977303/omniauth-facebook-certificate-verify-failed
# and https://github.com/intridea/omniauth/wiki/Setting-up-SSL-certificate-locations-in-Linux
if Rails.env.development? 
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE 
end

class FacebookAccount < LinkedAccount 
  attr_accessor :fb_user

  def facebook
    @fb_user ||= FbGraph::User.me(self.token)
  end
  
end

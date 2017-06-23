class LinkedAccount < ActiveRecord::Base
  attr_accessible :provider, :secret, :token, :uid, :user_id,:name
  belongs_to :user

  PROVIDERS = {
    :twitter => 1,
    :facebook => 2,
    :mixi => 3,
    :soundcloud => 4,
    :google => 5
  }

  after_create do 
    build_associated_user_account
  end


  def provider_name
    PROVIDERS.each do |k,v|
      if PROVIDERS[k] == provider
        return k
      end
    end
  end


  #THIS NEEDS TO BE PROVIDER SPECIFIC, GUY!!! If not, there may be collisions!
  def self.create_with_omniauth(auth, options={})
    provider = options[:provider]
    _user = options[:user]
    act = new do |account|
      account.uid = auth["uid"]
      account.name = auth["info"]["name"]
      account.nickname = auth["info"]["nickname"]
      account.token = auth["credentials"]["token"]
      account.secret = auth["credentials"]["secret"]
      account.provider = provider
    end
    
    if _user
      act.user_id = _user.id
    end
    
    act.tap do |a|
      a.save
    end
    
  end  
  
  private
  
  def build_associated_user_account
    if self.user_id.nil?
      user = User.create(:has_linked_account => true)
      self.update_attribute(:user_id,user.id)
      user.profile.update_attribute(:username, self.name)
    end
  end

end

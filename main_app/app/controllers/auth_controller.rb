class AuthController < ApplicationController


  def twitter_callback
    linked_account = TwitterAccount.find_by_uid(auth_hash["uid"]) || TwitterAccount.create_with_omniauth(auth_hash,:user => current_user, :provider => LinkedAccount::PROVIDERS[:twitter])
    puts "\n\n\nEMAIL IS #{auth_hash['info']['email']}\n\n\n"
    puts "\n\n\nHASH IS #{auth_hash}\n\n\n"
    if linked_account
      session[:user_id] = linked_account.user.id
      redirect_to links_path #add some message
    else
      redirect_to :root, :notice => ["Failed to Authenticate with Twitter!"]
    end    
  end

  def facebook_callback
    linked_account = FacebookAccount.find_by_uid(auth_hash["uid"]) || FacebookAccount.create_with_omniauth(auth_hash,:user => current_user, :provider => LinkedAccount::PROVIDERS[:facebook])
    puts "\n\n\nEMAIL IS #{auth_hash['info']['email']}\n\n\n"
    puts "\n\n\nHASH IS #{auth_hash}\n\n\n"
    if linked_account
      session[:user_id] = linked_account.user.id
      redirect_to links_path #add some message
    else
      redirect_to :root, :notice => ["Failed to Authenticate with Facebook!"]
    end    
  end

  def soundcloud_callback
    linked_account = SoundcloudAccount.find_by_uid(auth_hash["uid"]) || SoundcloudAccount.create_with_omniauth(auth_hash,:user => current_user, :provider => LinkedAccount::PROVIDERS[:soundcloud])
    puts "\n\n\nEMAIL IS #{auth_hash['info']['email']}\n\n\n"
    puts "\n\n\nHASH IS #{auth_hash}\n\n\n"
    if linked_account
      session[:user_id] = linked_account.user.id
      redirect_to links_path #add some message
    else
      redirect_to :root, :notice => ["Failed to Authenticate with Soundcloud!"]
    end    
  end

  def google_callback
    linked_account = GoogleAccount.find_by_uid(auth_hash["uid"]) || GoogleAccount.create_with_omniauth(auth_hash,:user => current_user, :provider => LinkedAccount::PROVIDERS[:google])
    puts "\n\n\nEMAIL IS #{auth_hash['info']['email']}\n\n\n"
    puts "\n\n\nHASH IS #{auth_hash}\n\n\n"
    if linked_account
      session[:user_id] = linked_account.user.id
      redirect_to links_path #add some message
    else
      redirect_to :root, :notice => ["Failed to Authenticate with Soundcloud!"]
    end    
  end

  def failure 

  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end

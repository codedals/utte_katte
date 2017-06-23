UtteKatte::Application.routes.draw do

  resources :profiles do 
    collection do 
      put 'update'
    end
  end

  resources :stores

  resources :purchases do
    collection do
      post 'purchase_email'
    end
  end

  match 'login'  => 'sessions#new',     :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'signup' => 'users#new',        :as => :signup
  match 'forgot' => 'users#forgot',        :as => :forgot

  match 'home' => 'users#home', :as => :home

  get "site/index"
  get "site/about"
  get "site/upload_test"

  resources :users do 
    collection do 
      post 'resend_verification_email'
    end
  end

  resources :sessions

  resources :links do 
    member do 
      post 'tweet_message'
      post 'facebook_feed_message'
    end
  end

  controller :auth do 
    match 'auth/twitter/callback' => 'auth#twitter_callback'
    match 'auth/facebook/callback' => 'auth#facebook_callback'
    match 'auth/soundcloud/callback' => 'auth#soundcloud_callback'
    match 'auth/google_oauth2/callback' => 'auth#google_callback'
  end


  controller :site do
    match 'about' => 'site#about', :as => :about
    match 'faq' => 'site#faq', :as => :faq
    match 'privacy-policy' => 'site#privacy_policy', :as => :privacy_policy
    match 'blog' => 'site#blog', :as => :blog
    match 'contacts' => 'site#contacts', :as => :contacts
    match 'terms-of-use' => 'site#terms_of_use', :as => :terms_of_use
    match 'how-it-works' => 'site#how_it_works', :as => :how_it_works
  end

  controller :links do
    match 'view_img' => 'links#view_img', :as => :view_img
    match 'view_video' => 'links#view_video', :as => :view_video
    match 'receipt' => 'links#receipt', :as => :receipt
    match 'options' => 'links#options', :as => :options
  end

  controller :users do
    match 'settings' => 'users#settings', :as => :settings
    match 'password' => 'users#password', :as => :password
    match 'customize' => 'users#customize', :as => :customize
    match 'buyer_information' => 'users#buyer_information', :as => :buyer_information
    match 'connection' => 'users#connection', :as => :connection
    match 'purchase_history' => 'users#purchases', :as => :purchase_history
  end

  match '/d/:key' => 'links#display', :as => :link_display

  match '/p/:download_key' => 'purchases#success', :as => :purchase_success

  match '/verify/:verification_key' => 'users#verify_email', :as => :verify_email

  match '/unlink/:provider' => 'linked_accounts#destroy', :as => :unlink_account, :method => :post
  
  root :to => 'site#index'

end

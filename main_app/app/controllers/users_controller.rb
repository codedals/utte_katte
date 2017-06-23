class UsersController < ApplicationController
  before_filter :login_required, :only => [:home]
  before_filter :admin_only, :only => [:index]

  def home
    @links = current_user.links.active
  end
  

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    if params[:index_register].present?
      @user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password])
    else
      @user = User.new(params[:user])
    end

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        UserMailer.verification_email(@user).deliver
        format.html { redirect_back_or_default links_path} #notice: 'User was successfully created.' 
        format.json { render json: @user, status: :created, location: @user }
      else
        #MC -- this is a mess..
        format.html { redirect_to root_path, :notice => [:email, :password].collect{|i| @user.errors[i]}.flatten}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :settings, :notice => @user.errors.keys.flatten}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def settings
    @class_settings = true
    @profile = current_user.profile
  end

  def password
    @class_password = true
  end

  def customize
    @class_customize = true
  end

  def buyer_information
    @class_buyer_information = true
  end

  def connection
    @class_connection = true
    @linked_accounts = current_user.linked_accounts
    
    @has_twitter = @linked_accounts.any?{|i| i.provider == LinkedAccount::PROVIDERS[:twitter]}
    @has_facebook = @linked_accounts.any?{|i| i.provider == LinkedAccount::PROVIDERS[:facebook]}
    @has_soundcloud = @linked_accounts.any?{|i| i.provider == LinkedAccount::PROVIDERS[:soundcloud]}
    
  end

  def verify_email
    @user = User.find_by_verification_key(params[:verification_key])
    if @user and @user.verify!
      session[:user_id] = @user.id
      redirect_back_or_default(links_path)
    else
      session[:user_id] = nil
      redirect_to :root  
    end
  end

  def resend_verification_email
    if current_user
      UserMailer.verification_email(current_user).deliver
      redirect_to links_path
    else
      redirect_to root_path 
    end
  end

  
  def purchases
    @class_purchases = true
    @purchases = current_user.purchases
  end

end

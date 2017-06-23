class SessionsController < ApplicationController
  before_filter :no_login_only, :only => [:new]


  def new 
  end

  def create
    
    @login = params[:login]
    @password = params[:password]

    if !params[:login].present? or !params[:password].present?
      redirect_to root_path and return
    end
    
    user = User.find_by_email(@login)
    
    respond_to do |format|
      if user && user.authenticate(@password)
        puts "USER LOGGED IN #{user.email}"
        format.html do 
          reset_session
          session[:user_id] = user.id
          redirect_back_or_default links_path#home_path
        end
        format.any(:xml, :json) { head :ok }
      else
        format.html do 
          flash.now[:error] = "Invalid login or password."
          #TODO -- redirect to "/forgot"
          redirect_to root_path, :alert => "Invalid login or password."
        end
        format.any(:xml, :json) { request_http_basic_authentication }
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end


end

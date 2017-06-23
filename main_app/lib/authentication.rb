module Authentication
  
  def self.included(controller)
    #allows these methods to be used in views 
    controller.send :helper_method, :has_valid_token?, :logged_in?, :current_token_user, :current_token, :current_user
  end
  
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth)
  end
  
  def logged_in?
    current_user
  end

  def no_login_only
    redirect_to home_path if logged_in?
  end

  def login_required
    return if logged_in?
      
    respond_to do |format| 
      format.html do
        save_location
        redirect_to login_url
      end
      format.any(:json, :xml) do
        unless login_from_basic_auth
          request_http_basic_authentication
        end
      end
    end 
  end

  def save_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def admin_domain_check
    unless ADMIN_DOMAINS.include?(SUBDOMAIN)
      redirect_to root_path unless ["development", "test"].include? Rails.env
    end
  end

  def admin_only
    unless current_user && current_user.admin
      raise ActionController::RoutingError.new("404") 
    end
  end
  
  protected
  

  def login_from_session
    User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def login_from_basic_auth
    user = authenticate_with_http_basic do |email, password|
      User.find_by_email(email).try(:authenticate, password)
    end
    session[:user_id] = user.id if user
    user
  end

end

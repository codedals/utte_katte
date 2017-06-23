class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authentication
  before_filter :set_locale

  def admin_only
    unless  current_user and current_user.role == User::ROLE[:admin]
      session[:user_id] = nil
      redirect_to :root
    end
  end

   
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end

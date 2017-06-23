class SiteController < ApplicationController

  def index
    redirect_to links_path if logged_in?
    @class_home = true
  end

  def about
    @class_about = true
  end

  def blog
    @class_blog = true
  end

  def contacts
    @class_contacts = true
  end

  def faq
    @class_faq = true
  end

  def how_it_works
    @class_how_it_works = true
  end

  def privacy_policy
    @class_privacy_policy = true
  end

  def terms_of_use
    @class_terms_of_use = true
  end

  def upload_test
    @links = current_user.links.active

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @links }
    end
  end

end

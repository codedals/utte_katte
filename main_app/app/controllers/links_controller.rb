class LinksController < ApplicationController
  before_filter :login_required, :only => [:index,:new,:create,:destroy]
  before_filter :redirect_to_full_url, :only => [:display]

  # GET /links
  # GET /links.json
  def index
    #puts "\n\n\Domain is #{request.domain}\n\n\n"
    @links = current_user.links

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @links }
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    #SET UP AUTHENTICATION TO VIEW THIS, ONLY OWNER CAN VIEW
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/new
  # GET /links/new.json
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find_by_identity_key(params[:id])
  end

  # POST /links
  # POST /links.json
  def create
    @link = current_user.links.new({
                                     :name => params[:link_name],
                                     :price => params[:link_price]
                                   })

    if params[:link_local_file].present? || params[:link_remote_file].present?
      @link.upload_tmp = params[:link_local_file]
    end

    respond_to do |format|
      if @link.save
        #MC -- TODO we need to handle this differently if a remote file.
        @link.save_upload(:upload_tmp => @link.upload_tmp)
        format.html { redirect_to edit_link_path(@link), notice: ['Link was successfully created.'] }
        format.json { render json: @link, status: :created, location: @link }
      else
        format.html { redirect_to links_path, :notice =>  @link.errors.values.flatten}
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @link = Link.find_by_identity_key(params[:id])

    respond_to do |format|
      if @link.update_attributes(:price => params[:link_price], 
                                 :name => params[:link_name], 
                                 :description => params[:link_description], 
                                 :active => params[:link_active])
        @link.save_upload(:upload_tmp => params[:upload_tmp]) if params[:upload_tmp].present?
        format.html { redirect_to edit_link_path(@link), notice: 'Link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_link_path(@link), :notice => @link.errors.values.flatten }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :no_content }
    end
  end

  #this is what the BUYER WILL SEE
  def display
    @link = Link.find_by_identity_key(params[:key])
    if @link.user != current_user and !@link.active
      redirect_to root_path
    end
    @link.increase_views_count! unless @link.user == current_user
  end

  def view_img

  end

  def tweet_message
    @link = Link.find_by_identity_key(params[:id])
    if current_user != @link.user
      session[:user_id] = nil
      redirect_to :root and return 
    end
    if !current_user.twitter_account.nil?
      current_user.twitter_account.tweet("Check out my new creation: http://deji.co/d/#{@link.identity_key}")
    else
      redirect_to(:connection, :notice => ["Link your Twitter account!"]) and return
    end
    redirect_to :back, :notice => ["Successfully Tweeted your link!"]
  end

  def facebook_feed_message
    @link = Link.find_by_identity_key(params[:id])
    if current_user != @link.user
      session[:user_id] = nil
      redirect_to :root and return 
    end
    if !current_user.facebook_account.nil?
      current_user.facebook_account.facebook.feed!(:message =>"Check out my new creation: http://deji.co/d/#{@link.identity_key}", :name => "My New Product on Dejisute!")
    else
      redirect_to(:connection, :notice => ["Link your Facebook account!"]) and return
    end
    redirect_to :back
  end

  private 

  def redirect_to_full_url
    if request.domain == "deji.co"
      redirect_to "http://dejisute.com/d/#{params[:key]}"
    end
  end


end

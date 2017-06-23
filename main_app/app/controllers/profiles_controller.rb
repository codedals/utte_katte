class ProfilesController < ApplicationController
  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = Profile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.json
  #We shouldnt even need this action
  # def create
  #   @profile = current_user.build_profile(params[:profile])

  #   respond_to do |format|
  #     if @profile.save
  #       format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
  #       format.json { render json: @profile, status: :created, location: @profile }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @profile.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /profiles/1
  # PUT /profiles/1.json

  def update
    @profile = current_user.profile

    respond_to do |format|
      if @profile.update_attributes(:username => params[:profile_username],
                                    :fullname => params[:profile_fullname],
                                    :bio => params[:profile_bio]
                                    )
        #still need to alert user if things dont work
        if params[:user_email].present?
          current_user.update_attributes(:email => params[:user_email])
        end
        format.html { redirect_to settings_path, notice: ['Profile was successfully updated.'] }
        format.json { head :no_content }
      else
        format.html { redirect_to settings_path, :notice => @profile.errors.keys.flatten }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end
end

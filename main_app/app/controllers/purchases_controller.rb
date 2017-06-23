class PurchasesController < ApplicationController
  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchases }
    end
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/new
  # GET /purchases/new.json
  def new
    @purchase = Purchase.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/1/edit
  def edit
    @purchase = Purchase.find(params[:id])
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @link = Link.find_by_identity_key(params[:identity_key])
    unless @link
      redirect_to root_path and return 
    end
    if !@link.try(:active)
      redirect_to root_path and return 
    end
    @purchase = @link.purchases.new(params[:purchase]).tap do |purchase|
      purchase.save
      purchase.update_attribute(:token, params[:stripeToken]) 
      purchase.update_attribute(:email, params[:email])
    end
    
    #MC -- what is this transaction doing?
    @transaction = @purchase.perform_purchase!

    if current_user
      @purchase.update_attribute(:user_id, current_user.id)
      UserMailer.purchase_email(current_user.email, @purchase).deliver
    end

    redirect_to  purchase_success_path(@purchase.unique_download_key)
  end

  def success
    @purchase = Purchase.find_by_unique_download_key(params[:download_key])
    @purchase.increase_views_count!
    @link = @purchase.link
  end

  def purchase_email
    @purchase = Purchase.find_by_unique_download_key(params[:download_key])
    @email = params[:user_email]
    if params[:user_email].present?
      UserMailer.purchase_email(@email, @purchase).deliver
      redirect_to purchase_success_path(@purchase.unique_download_key), :notice => "Email Sent!"
    else
      redirect_to purchase_success_path(@purchase.unique_download_key), :notice => "Please enter a valid email address!"
    end
  end
  

  # PUT /purchases/1
  # PUT /purchases/1.json
  def update
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      if @purchase.update_attributes(params[:purchase])
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase = Purchase.find(params[:id])
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :no_content }
    end
  end
end

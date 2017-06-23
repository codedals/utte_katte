class LinkedAccountsController < ApplicationController

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @linked_account = current_user.linked_accounts.find(:first, :conditions => ["provider = ?", LinkedAccount::PROVIDERS[params[:provider].to_sym]])

    @linked_account.try(:destroy)

    respond_to do |format|
      format.html { redirect_to :connection }
      format.json { head :no_content }
    end
  end


end

class AddFbTokenToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :fb_token, :string
  end
end

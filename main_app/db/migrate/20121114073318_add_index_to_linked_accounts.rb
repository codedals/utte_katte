class AddIndexToLinkedAccounts < ActiveRecord::Migration
  def change
    add_index :linked_accounts, :user_id
  end
end

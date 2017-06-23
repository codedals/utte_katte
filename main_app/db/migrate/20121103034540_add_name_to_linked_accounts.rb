class AddNameToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :name, :string
  end
end

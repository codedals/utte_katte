class AddTypeToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :type, :string
  end
end

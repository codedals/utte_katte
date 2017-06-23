class AddNicknameToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :nickname, :string
  end
end

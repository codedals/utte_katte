class AddHasLinkedAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_linked_account, :boolean
  end
end

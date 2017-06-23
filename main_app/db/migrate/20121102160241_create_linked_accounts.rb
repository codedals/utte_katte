class CreateLinkedAccounts < ActiveRecord::Migration
  def change
    create_table :linked_accounts do |t|
      t.integer :user_id
      t.integer :provider
      t.string :uid
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end

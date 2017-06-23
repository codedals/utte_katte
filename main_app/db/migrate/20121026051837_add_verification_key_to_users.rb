class AddVerificationKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :verification_key, :string
  end
end

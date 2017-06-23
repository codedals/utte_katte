class AddIndexToPurchases < ActiveRecord::Migration
  def change
    add_index :purchases, [:link_id,:user_id]
  end
end

class AddIndexToStores < ActiveRecord::Migration
  def change
    add_index :stores, :user_id
  end
end

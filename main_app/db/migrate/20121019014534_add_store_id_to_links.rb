class AddStoreIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :store_id, :integer
  end
end

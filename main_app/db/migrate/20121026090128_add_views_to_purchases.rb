class AddViewsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :views, :integer
  end
end

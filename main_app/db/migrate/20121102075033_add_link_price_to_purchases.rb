class AddLinkPriceToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :link_price, :float
  end
end

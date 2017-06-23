class AddLinkNameToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :link_name, :string
  end
end

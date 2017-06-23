class AddLinkIdToPurchaseTransactions < ActiveRecord::Migration
  def change
    add_column :purchase_transactions, :link_id, :integer
  end
end

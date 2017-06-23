class AddIndexToPurchaseTransactions < ActiveRecord::Migration
  def change
    add_index :purchase_transactions, [:purchase_id,:link_id]
  end
end

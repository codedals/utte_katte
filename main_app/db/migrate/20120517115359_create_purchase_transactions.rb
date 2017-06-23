class CreatePurchaseTransactions < ActiveRecord::Migration
  def change
    create_table :purchase_transactions do |t|
      t.integer :purchase_id
      t.string :response_data

      t.timestamps
    end
  end
end

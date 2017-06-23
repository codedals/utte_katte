class ChangeResponseDataToTextInPurchaseTransction < ActiveRecord::Migration
  def up
    change_column :purchase_transactions, :response_data, :text
  end

  def down
    change_column :purchase_transactions, :response_data, :string
  end
end

class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :link_id
      t.integer :user_id
      t.boolean :successful
      t.integer :state

      t.timestamps
    end
  end
end

class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :user_id
      t.string :name
      t.string :upload_path
      t.string :url
      t.float :price

      t.timestamps
    end
  end
end

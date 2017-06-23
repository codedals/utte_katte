class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :fullname
      t.string :bio
      t.string :username
      t.string :settings

      t.timestamps
    end
  end
end

class AddActiveAndDeletedToLinks < ActiveRecord::Migration
  def change
    add_column :links, :active, :boolean, :default => true
    add_column :links, :deleted, :boolean, :default => false
  end
end

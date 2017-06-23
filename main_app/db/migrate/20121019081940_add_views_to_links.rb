class AddViewsToLinks < ActiveRecord::Migration
  def change
    add_column :links, :views, :integer
  end
end

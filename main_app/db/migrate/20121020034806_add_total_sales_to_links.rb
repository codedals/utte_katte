class AddTotalSalesToLinks < ActiveRecord::Migration
  def change
    add_column :links, :total_sales, :float
  end
end

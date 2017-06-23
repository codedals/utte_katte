class AddUniqueUrlToLinks < ActiveRecord::Migration
  def change
    add_column :links, :unique_url, :string
  end
end

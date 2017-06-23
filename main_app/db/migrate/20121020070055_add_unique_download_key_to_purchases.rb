class AddUniqueDownloadKeyToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :unique_download_key, :string
  end
end

class AddPreviewFilePathToLinks < ActiveRecord::Migration
  def change
    add_column :links, :preview_file_path, :string
  end
end

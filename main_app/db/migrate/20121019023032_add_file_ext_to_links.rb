class AddFileExtToLinks < ActiveRecord::Migration
  def change
    add_column :links, :file_ext, :integer
  end
end

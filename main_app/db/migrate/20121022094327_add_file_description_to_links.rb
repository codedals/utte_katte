class AddFileDescriptionToLinks < ActiveRecord::Migration
  def change
    add_column :links, :file_description, :text
  end
end

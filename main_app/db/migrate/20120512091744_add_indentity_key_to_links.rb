class AddIndentityKeyToLinks < ActiveRecord::Migration
  def change
    add_column :links, :identity_key, :string
  end
end

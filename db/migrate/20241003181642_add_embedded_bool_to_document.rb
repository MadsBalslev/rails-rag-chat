class AddEmbeddedBoolToDocument < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :embedded, :boolean, default: false
  end
end

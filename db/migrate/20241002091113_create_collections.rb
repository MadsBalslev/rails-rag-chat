class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.string :title, null: false
      t.text :description, null: true

      t.timestamps
    end

    add_reference :documents, :collection, foreign_key: true
  end
end

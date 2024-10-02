class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.string :title, null: false
      t.text :description, null: true
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end

    add_reference :documents, :collection, foreign_key: true, null: false
  end
end

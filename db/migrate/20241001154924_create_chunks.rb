class CreateChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :chunks do |t|
      t.references :chunkable, polymorphic: true, null: false, index: true
      t.text :chunk, null: false
      t.integer :position, null: true
      t.timestamps
    end
  end
end

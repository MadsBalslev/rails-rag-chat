class CreateMessageChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :message_chunks do |t|
      t.references :message, null: false, foreign_key: true
      t.references :chunk, null: false, foreign_key: true

      t.timestamps
    end
  end
end

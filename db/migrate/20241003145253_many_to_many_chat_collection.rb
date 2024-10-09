class ManyToManyChatCollection < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_collections do |t|
      t.references :chat, null: false, foreign_key: { on_delete: :cascade }
      t.references :collection, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end

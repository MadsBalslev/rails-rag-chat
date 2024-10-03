class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end

class CreateChatCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_collections do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true
      t.timestamps
    end
  end
end

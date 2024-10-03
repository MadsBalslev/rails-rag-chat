class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end

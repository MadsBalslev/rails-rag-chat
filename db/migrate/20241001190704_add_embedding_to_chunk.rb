class AddEmbeddingToChunk < ActiveRecord::Migration[8.0]
  def change
    add_column :chunks, :embedding, :vector, limit: 1536
  end
end

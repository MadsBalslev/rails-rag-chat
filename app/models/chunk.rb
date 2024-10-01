class Chunk < ApplicationRecord
  belongs_to :chunkable, polymorphic: true

  after_create :create_embedding

  private

  def create_embedding
    EmbedChunkJob.perform_later(chunk_id: id)
  end
end

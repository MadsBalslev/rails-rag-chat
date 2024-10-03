class Chunk < ApplicationRecord
  belongs_to :chunkable, polymorphic: true

  has_many :message_chunks, dependent: :destroy

  has_neighbors :embedding

  after_create :create_embedding

  private

  def create_embedding
    EmbedChunkJob.perform_later(chunk_id: id)
  end
end

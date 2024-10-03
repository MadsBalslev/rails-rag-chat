class EmbedChunkJob < ApplicationJob
  queue_as :default

  def perform(chunk_id:)
    # Do something later
    chunk = Chunk.find(chunk_id)

    embedding = EmbedService.new(content: chunk.chunk).embed
    chunk.update(embedding: embedding)
  end
end

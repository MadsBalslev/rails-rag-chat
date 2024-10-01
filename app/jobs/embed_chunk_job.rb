class EmbedChunkJob < ApplicationJob
  queue_as :default

  def perform(chunk_id:)
    # Do something later
    chunk = Chunk.find(chunk_id)

    client = OpenAI::Client.new
    response = client.embeddings(parameters: {
      model: "text-embedding-3-small",
      input: chunk.chunk
    })

    embedding = response.dig("data", 0, "embedding")
    chunk.update(embedding: embedding)
  end
end

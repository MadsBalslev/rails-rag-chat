class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user, optional: true
  has_many :message_chunks, dependent: :destroy
  has_many :chunks, through: :message_chunks

  after_create :generate_response

  def sources
    return nil unless chunks.present?

    # Return list of all unique sources with a list of the chunk postions for each source
    # Chunk: <chunkable, position, text>
    # Chunkable: <document_id, name>

    sources = {}
    chunks.each do |chunk|
      source = chunk.chunkable.name
      position = chunk.position
      sources[source] ||= {
        document_id: chunk.chunkable_id,
        positions: []
      }
      sources[source][:positions] << position
    end

    sources
  end

  private

  def generate_response
    return unless user.present?

    embedded_msg = EmbedService.new(content: content).embed

    relevant_chunks = Chunk.nearest_neighbors(:embedding, embedded_msg, distance: "cosine").limit(5)
    chat.messages.create(user: nil, content: "Here are some relevant chunks:", chunks: relevant_chunks)
  end
end

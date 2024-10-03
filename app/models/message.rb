class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user, optional: true

  after_create :generate_response

  private

  def generate_response
    return unless user.present?

    embedded_msg = EmbedService.new(content: content).embed

    relevant_chunks = Chunk.nearest_neighbors(:embedding, embedded_msg, distance: "cosine").first(5)
    relevant_chunks.each do |chunk|
      chat.messages.create(user: nil, content: chunk.chunk)
    end
  end
end

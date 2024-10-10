class Message < ApplicationRecord
  belongs_to :chat, touch: true
  belongs_to :user, optional: true
  has_many :message_chunks, dependent: :destroy
  has_many :chunks, through: :message_chunks

  validates :content, presence: true

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
    question = self.content
    relevant_chunks = RelevantChunkFinder.new(message: self, chat_id: chat_id, k: 10).relevant_chunks
    answer = RagAnswerService.new(chunks: relevant_chunks, question: question, chat_id: chat_id).call

    chat.messages.create(user: nil, content: answer, chunks: relevant_chunks)
  end
end

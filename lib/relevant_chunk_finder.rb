class RelevantChunkFinder
  def initialize(message:, chat_id:)
    @message = message
    @chat = Chat.find(chat_id)
  end

  def embed_message
    embedded_msg = EmbedService.new(content: @message.content).embed
    embedded_msg
  end

  def relevant_chunks
    embedded_msg = embed_message

    # Only look a chunks that are owned by the user (chat.user.chunks)
    chunks = @chat.chunks.nearest_neighbors(:embedding, embedded_msg, distance: "cosine").limit(5)
    chunks
  end
end

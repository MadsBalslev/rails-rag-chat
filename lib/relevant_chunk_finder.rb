class RelevantChunkFinder
  def initialize(message:, chat_id:, k: 5)
    @message = message
    @chat = Chat.find(chat_id)
    @k = k
  end

  def embed_message
    embedded_msg = EmbedService.new(content: @message.content).embed
    embedded_msg
  end

  def relevant_chunks
    embedded_msg = embed_message
    # chunks = @chat.chunks

    # Only look a chunks that are owned by the user (chat.user.chunks)
    relevant_chunks = Chunk.nearest_neighbors(:embedding, embedded_msg, distance: "cosine").limit(@k)

    relevant_chunks
  end
end

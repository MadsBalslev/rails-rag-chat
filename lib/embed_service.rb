class EmbedService
  def initialize(content:)
    @client = OpenAI::Client.new
    @content = content
  end

  def embed
    response = @client.embeddings(parameters: {
      model: "text-embedding-3-small",
      input: @content
    })

    response.dig("data", 0, "embedding")
  end
end

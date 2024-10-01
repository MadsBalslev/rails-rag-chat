class EmbedChunkJob < ApplicationJob
  queue_as :default

  def perform(chunk_id:)
    # Do something later
    puts "Embedding chunk with ID #{chunk_id}"
  end
end

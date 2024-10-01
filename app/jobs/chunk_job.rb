class ChunkJob < ApplicationJob
  queue_as :default

  def perform(chunk_size: 250, chunk_overlap: 50, chunkable_type:, chunkable_id:)
    chunkable = chunkable_type.constantize.find(chunkable_id)

    raw_text_with_location = chunkable.get_text_with_location # => [[page_number, text], ...]]

    chunks = create_chunks(raw_text_with_location, chunk_size, chunk_overlap)

    logger.info "Saving #{chunks.size} chunks for #{chunkable_type} with ID #{chunkable_id}"

    save_chunks(chunks, chunkable)
  end

  private

  def create_chunks(raw_text_with_location, chunk_size, chunk_overlap)
    all_chunks = []
    previous_overlap = []

    raw_text_with_location.each do |(page_number, text)|
      words = text.split # Split the current page's text into words

      # Include the overlap from the previous page if applicable
      words = previous_overlap + words
      previous_overlap = [] # Reset the overlap for the next page

      while words.size >= chunk_size
        # Take a full chunk from the words
        chunk = words.shift(chunk_size)

        # Add the chunk to the final output along with the page number
        all_chunks << { text: chunk.join(" "), page: page_number }

        # Prepare the overlap for the next chunk
        previous_overlap = chunk.last(chunk_overlap)
      end

      # Save the leftover words (less than a chunk) for the next page
      if words.size > 0
        previous_overlap = words.last(chunk_overlap) # Only retain up to the overlap size
      end
    end

    # Handle the last chunk if there are leftover words
    if previous_overlap.size > 0
      all_chunks << { text: previous_overlap.join(" "), page: raw_text_with_location.last[0] }
    end

    all_chunks
  end

  def save_chunks(chunks, chunkable)
    chunks.each do |chunk|
      chunkable.chunks.create!(chunk: chunk[:text], position: chunk[:page])
    end
  end
end

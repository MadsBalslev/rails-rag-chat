class Document < ApplicationRecord
  include Chunkable

  belongs_to :collection

  before_save :set_document_title
  after_update_commit :all_chunks_embedded?

  def get_text_with_location
    return unless self.file.attached?

    # Handle PDFs
    if self.file.content_type == "application/pdf"
      pdf = PDF::Reader.new(self.file_path)

      # Return an array of page numbers and text content
      pdf.pages.each.map { |page| [ page.number, page.text ] }

    elsif file.content_type == "text/plain"
      # Treat the entire file as a single page with page number as nil
      [ [ nil, file.download ] ]
    else
      raise "Unsupported file type"
    end
  end

  private

  def set_document_title
    self.name = file.filename.to_s if name.blank?
  end

  def all_chunks_embedded?
    return unless chunks.present?
    if chunks.where(embedding: nil).none?
      update(embedded: true) unless embedded?
    end
  end
end

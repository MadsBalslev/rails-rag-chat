class Document < ApplicationRecord
  include Chunkable

  belongs_to :user
  belongs_to :collection

  before_save :set_document_title

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

  def embedded?
    return false unless self.chunks.exists?

    self.chunks.all? { |chunk| chunk.embedding.present? }
  end

  private

  def set_document_title
    self.name = file.filename.to_s if name.blank?
  end
end

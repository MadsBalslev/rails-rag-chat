class Document < ApplicationRecord
  belongs_to :user

  has_one_attached :file

  validates :file, presence: true

  before_save :set_document_title

  def set_document_title
    self.name = file.filename.to_s if name.blank?
  end
end

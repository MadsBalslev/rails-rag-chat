module Chunkable
  extend ActiveSupport::Concern
  included do
    has_many :chunks, as: :chunkable, dependent: :destroy
    has_one_attached :file, dependent: :destroy

    validates :file, presence: true

    after_commit :chunk, on: :create

    def file_path
      ActiveStorage::Blob.service.path_for(file.key)
    end


    def chunk
      return if self.chunks.present?
      return unless self.file.attached?

      ChunkJob.perform_later(chunkable_type: self.class.name, chunkable_id: self.id)
    end
  end
end

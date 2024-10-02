class Collection < ApplicationRecord
  has_many :documents, dependent: :destroy

  validates :title, presence: true
end

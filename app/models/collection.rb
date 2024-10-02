class Collection < ApplicationRecord
  has_many :documents, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
end

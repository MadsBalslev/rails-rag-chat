class Collection < ApplicationRecord
  has_many :documents, dependent: :destroy
  has_many :chat_collections
  has_many :chats, through: :chat_collections
  belongs_to :user

  validates :title, presence: true
end

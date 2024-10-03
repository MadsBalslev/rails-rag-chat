class Chat < ApplicationRecord
  belongs_to :user
  has_many :chat_collections
  has_many :collections, through: :chat_collections
  has_many :messages, dependent: :destroy
  has_many :documents, through: :collections
end

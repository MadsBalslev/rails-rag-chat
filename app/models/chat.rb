class Chat < ApplicationRecord
  belongs_to :user
  has_many :chat_collections
  has_many :collections, through: :chat_collections
  has_many :messages, dependent: :destroy
  has_many :documents, through: :collections
  has_many :chunks, through: :documents

  after_create_commit :set_default_title

  private

  def set_default_title
    index = user.chats.count + 1
    update(title: "Chat ##{index}") if title.blank?
  end
end

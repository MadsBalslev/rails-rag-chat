class Chat < ApplicationRecord
  belongs_to :user
  has_many :chat_collections
  has_many :collections, through: :chat_collections
  has_many :messages, dependent: :destroy
  has_many :documents, through: :collections
  has_many :chunks, through: :documents

  after_update_commit :set_title

  private

  def set_title
    return unless messages.length > 0
    title = messages.first.content
    update(title: title)
  end
end

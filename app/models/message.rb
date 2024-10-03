class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user, optional: true

  after_create :mock_ai_response

  private

  def mock_ai_response
    return unless user.present?

    Message.create!(chat: chat, user: nil, content: "I'm a bot and I'm here to help you!")
  end
end

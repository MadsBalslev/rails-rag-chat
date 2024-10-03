class MessagesController < ApplicationController
  before_action :find_chat

  def create
    @message = Message.build(message_params)
    @message.user = current_user
    if @chat.present?
      @message.chat = @chat
    else
      @message.chat = Chat.create!(messages: [ @message ], user: current_user)
    end

    if @message.save
      redirect_to chat_path(@message.chat)
    else
      render "chats/index"
    end
  end

  private

  def find_chat
    if message_params[:chat_id]
      @chat = Chat.find(message_params[:chat_id]) rescue nil
    end
  end
  def message_params
    params.require(:message).permit(:content, :chat_id)
  end
end

class MessagesController < ApplicationController
  before_action :find_chat

  def create
    @message = Message.build(message_params)
    @message.user = current_user
    @collection_ids = params[:message][:collection_ids]


    if @collection_ids.empty?
      flash[:warning] = "Please select at least one collection"
      return redirect_to chats_path
    end

    if @chat.present?
      @message.chat = @chat
    else
      @message.chat = Chat.create!(messages: [ @message ], user: current_user)
      @collection_ids.each do |collection_id|
        collection = polocy_scope(Collection).find(collection_id) rescue nil
        if collection
          @message.chat.collections << collection
        end
      end

      @message.chat.save!
    end

    if @message.save
      redirect_to chat_path(@message.chat)
    else
      flash[:error] = @message.errors.full_messages.join(", ")
      redirect_to chats_path
    end
  end

  private

  def find_chat
    if message_params[:chat_id]
      @chat = Chat.find(message_params[:chat_id]) rescue nil
    end
  end
  def message_params
    params.require(:message).permit(:content, :chat_id, :collection_ids)
  end
end

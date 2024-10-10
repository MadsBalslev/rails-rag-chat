class MessagesController < ApplicationController
  before_action :find_chat

  def create
    @message = Message.build(message_params)
    @message.user = current_user
    @collection_ids = params[:chat][:collection_ids]


    if @collection_ids.empty?
      flash[:warning] = "Please select at least one collection"
      return redirect_to chats_path
    end

    if !@chat.present?
      @chat = Chat.create!(messages: [], user: current_user)

      @collection_ids.each do |collection_id|
        collection = policy_scope(Collection).find(collection_id) rescue nil
        if collection
          ChatCollection.create!(chat: @chat, collection: collection)
        end
      end
    end

    @message.chat = @chat

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

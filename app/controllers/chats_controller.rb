class ChatsController < ApplicationController
  before_action :find_previous_chats

  def index
    @collections = policy_scope(Collection)
    @chat = Chat.new
  end

  def show
    @chat = policy_scope(Chat).find(params[:id]) rescue nil

    if !@chat && params[:id]
      return redirect_to chats_path
    end

    authorize @chat

    @messages = @chat.messages
    @collections = @chat.collections

    render :index
  end

  def edit
    @chat = policy_scope(Chat).find(params[:id]) rescue nil
    authorize @chat
  end

  def update
    @chat = policy_scope(Chat).find(params[:id]) rescue nil
    authorize @chat

    @chat.update(chat_params)
    respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "chats",
            partial: "chats/chat",
            collection: policy_scope(Chat).all
          )
        end
        format.html do
          redirect_to chat_path(@chat), notice: "The chat has been updated."
        end
    end
  end

  def destroy
    @chat = policy_scope(Chat).find(params[:id]) rescue nil
    if @chat
      authorize @chat
      @chat.destroy
    end
    redirect_to chats_path
  end

  private

  def find_previous_chats
    @chats = policy_scope(Chat).all
  end

  def chat_params
    params.require(:chat).permit(:title)
  end
end

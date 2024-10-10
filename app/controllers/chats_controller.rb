class ChatsController < ApplicationController
  before_action :find_previous_chats

  def index
    @collections = policy_scope(Collection)
    @chat = Chat.new
  end

  def show
    @chat = policy_scope(Chat).find(params[:id]) rescue nil
    @collections = @chat.collections

    if !@chat && params[:id]
      return redirect_to chats_path
    end

    authorize @chat

    @messages = @chat.messages

    render :index
  end

  private

  def find_previous_chats
    @chats = policy_scope(Chat).all
  end
end

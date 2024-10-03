class ChatsController < ApplicationController
  before_action :find_previous_chats

  def index
  end

  def show
    @current_chat = policy_scope(Chat).find(params[:id]) rescue nil

    if !@current_chat && params[:id]
      return redirect_to chats_path
    end

    authorize @current_chat

    @messages = @current_chat.messages

    render :index
  end

  private

  def find_previous_chats
    @chats = policy_scope(Chat).all
  end
end

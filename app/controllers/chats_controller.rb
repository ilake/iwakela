class ChatsController < ApplicationController
  helper :all
  before_filter :check_auth, :only => 'create'

  def create
    params[:chats][:group_id] = params[:group_id]
    @me.chats.create(params[:chats])
    redirect_to :back
  end

  def list
    @lazy_users = User.find_fight_user_result(true, 2)
    @early_users= User.find_fight_user_result(true, 1)
    @chat = Chat.find_some_chats(params[:page], 20)
  end
end

class ChatsController < ApplicationController
  helper :all
  before_filter :check_auth, :only => 'create'

  def create
    params[:chats][:group_id] = params[:group_id]
    @me.chats.create(params[:chats])
    redirect_to :back
  end

  def list
    @lazy_users = User.today_earliest('fail')
    @early_users = User.today_earliest('success')
    @totoal_success = Record.wake.today.success.count
    @totoal_fail = Record.wake.today.fail.count
    @chat = Chat.find_some_chats(params[:page], 20)
  end
end

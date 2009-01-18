class ChatsController < ApplicationController
  helper :all
  before_filter :check_auth, :only => 'create'

  def create
    redirect_to :back and return unless params[:chats]
    params[:chats][:group_id] = params[:group_id]
    @me.chats.create(params[:chats])
    redirect_to :back
  end

  def list
    @lazy_users = User.today_earliest('fail')
    @early_users = User.today_earliest('success')
    @totoal_success = Record.wake.success.count(:all, :conditions => ["records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"])
    @totoal_fail = Record.wake.fail.count(:all, :conditions => ["records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"])
    @chat = Chat.find_some_chats(params[:page], 20)
  end
end

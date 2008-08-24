class FriendController < ApplicationController
  before_filter :check_auth
  helper :all

  def add_friend
    if request.post?
      if user = User.find_by_name(params[:name])
        if !(@me.friends.include?(user)) && user.id != @me.id && @me.friends << user 
          flash[:notice] = '加入完成'
        else
          flash.now[:notice] = "他已經是你的好友了"
        end
      else
        flash.now[:notice] = '沒有這個使用者喔'
      end
    end
    @users = User.find(:all, :order => "created_at DESC",:limit => 10)
  end

  def destroy
    if friend = User.find(:first, :conditions => ["id = ?", params[:id]])
      @me.friends.delete(friend) if @me.friends.include?(friend)
    end
    redirect_to :action => :add_friend
  end
end

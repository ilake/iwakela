class FriendController < ApplicationController
  before_filter :check_auth, :except => :list
  helper :all

  def list
    @user = User.find(params[:id])
    @friends = @user.friends.paginate :page => params[:page],
                                      :per_page => 12,
                                      :include => [:profile, :mugshot],
                                      :order => "users.id DESC"
    @num = @friends.size
    render :action => 'index'
  end

  def list_friends
    @user = User.find(params[:id])
    @friends = @user.be_friends.paginate :page => params[:page],
                                      :per_page => 12,
                                      :include => [:profile, :mugshot],
                                      :order => "users.id DESC"
    @num = @user.friends.count
    render :action => 'index'
  end

  def list_user_rank
    @user = User.find(params[:id])
    friends = @user.friends 
    friends << @user
    @users = friends.find_friends_rank(params[:page], params[:sort])
    #因為 << 會把自己加進去 , 所以加完之後 再把自己砍掉, 自己不會是自己的朋友
    @user.friends.delete(@user)
  end

  def add_friend
    if request.post?
      if user = User.find_by_name(params[:name])
        if !(@me.friends.include?(user)) && user.id != @me.id && @me.friends << user 
          notice_stickie("加入完成")
        else
          warning_stickie("他已經是你的好友了")
        end
      else
        error_stickie('沒有這個使用者喔')
      end

      redirect_to :back
    end
    @friends = @me.friends.find(:all, :include => :mugshot)
    @users = User.find(:all, :include => :mugshot, :order => "created_at DESC",:limit => 10)

  end

  def destroy
    if friend = User.find(:first, :conditions => ["id = ?", params[:id]])
      @me.friends.delete(friend) if @me.friends.include?(friend)
      notice_stickie("刪除成功")
    end
    redirect_to :action => :add_friend
  end
end

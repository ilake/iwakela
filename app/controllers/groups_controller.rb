class GroupsController < ApplicationController
  helper :all
  before_filter :check_auth, :except =>[:index, :show]

  def index 
    @public_groups = Group.find(:all, :conditions =>"state = 0 or state = 2", :order => 'id DESC')
    @private_groups = Group.find(:all, :conditions =>"state = 1 or state = 3", :order => 'id DESC')
  end

  def list
    @group = Group.find(params[:id])
    @members = @group.members.find_all_members(params[:page])
  end

  def show 
    @group = Group.find(params[:id])
    @chat = @group.chats.find_some_chats(params[:page], 20, @group.id)
    @forums = @group.forums.find(:all, :order => 'id DESC', :limit => 4)

    @members = @group.members.find(:all, :include => 'status', :order => "statuses.group_join_date DESC", :limit => 10)

    @absence_rank_members = @group.members.find(:all, :include => 'status', :order => 'statuses.attendance DESC')

    @score_rank_members = @group.members.find(:all, :include => 'status', :order => 'statuses.score DESC')

    @absence_members = @group.members.find_group_user_result(0)
    @success_members = @group.members.find_group_user_result(1)
    @fail_members = @group.members.find_group_user_result(2)
    @sick_members = @group.members.find_group_user_result(3)

    Group.increment_counter(:readed, @group.id)
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    g = params[:group]

    if g[:pri] == "1"
      if g[:fill] == "1"
        g[:state] = 3
      else
        g[:state] = 1
      end
    else
      if g[:fill] == "1"
        g[:state] = 2
      else
        g[:state] = 0
      end
    end

    g.delete(:fill)
    g.delete(:pri)


    if @group.update_attributes(g)
      flash[:notice] = '更新成功'
      redirect_to :action => 'show', :id => @group
    else
      render :action => 'edit'
    end
  end

  def create
    unless @me.group
      g = params[:group]
      g[:state] = g[:pri]=='1' ? 1 : 0
      g[:owner_id] = @me.id

      g.delete(:fill)
      g.delete(:pri)

      if @group = Group.create(params[:group])
        if @group.errors.empty? && @me.change_group(@group)
          flash[:notice] = "開團成功"
          redirect_to :action => "show", :id => @group.id
        else
          flash[:notice] = "開團失敗, 請重新在設定一次"
          redirect_to :action => "new"
        end
      else
        flash[:notice] = "開團失敗, 請重新在設定一次"
        redirect_to :action => "new"
      end
    else
      flash[:notice] = "一個人限開一團"
      redirect_to :action => "index"
    end
  end

  def join
    @group = Group.find(params[:id])
    if @group.get_in?(@me) && @me.change_group(@group)
      flash[:notice] = "加入成功"
      redirect_to :action => "show", :id => @group.id
    else
      flash[:notice] = "你已經有參加其他團了或者是團隊已滿"
      redirect_to :action => "index"
    end
  end

  def invite
    @group = Group.find(params[:id])
    if user = User.find_by_name(params[:user][:name])
      if @group.get_in?(user) && @group.owner == @me && user.change_group(@group)
        flash[:notice] = '加入完成'
        redirect_to :action => "show", :id => @group.id
      else
        flash[:notice] = "他已經有參加其他團了或者是團隊已滿"
        redirect_to :action => "index"
      end
    else
      flash[:notice] = '沒有這個使用者喔'
      redirect_to :back
    end
  end

  def fire
    if params[:id] == @me.id
      flash[:notice] = '沒有在開除自己的啦'
    else
      @user = @me.own_group.members.find(params[:id])
      @user.change_group(nil, nil)
    end
    redirect_to :action => "show", :id => @me.own_group
  end

  def quit 
    if @me.own_group
      flash[:notice] = '必須把團長移交給其他人才可以退團'
    elsif @me.group
      @me.change_group(nil, nil)
    end

    redirect_to :action => "index"
  end

  def transfer
    if @user = @me.own_group.members.find_by_name(params[:user][:name])
      @group.owner = @user
      @group.save

      flash[:notice] = '移交完成'
      redirect_to :action => "show", :id => @group.id
    else
      flash[:notice] = '沒有該名使用者或者該使用者不是本團團員'
      redirect_to :back
    end
  end

  def absence
    if params[:absence] == '1'
      flash[:notice] = '請假成功(沒來做紀錄將一直保持請假)'
      @me.status.update_attribute(:fight, false)
    else
      flash[:notice] = '已經取消請假狀態'
      @me.status.update_attribute(:fight, true)
    end
    redirect_to :action => "show", :id => params[:id]
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = '解散成功'
    redirect_to :action => "index"
  end

  def edit_member_title
    @user = @me.own_group.members.find(params[:id])
    if request.post?
      @user.update_attribute(:group_nickname, params[:user][:group_nickname])
      redirect_to :action => 'list', :id => @me.own_group
    end
  end
end

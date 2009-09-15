class GroupsController < ApplicationController
  helper :all
  before_filter :check_auth, :except =>[:index, :show]

  def index 
    @latest_groups = Group.find(:all, :include => [:mugshot], :order => 'id DESC', :limit => 5)
    @hottest_groups = Group.find_all_group(params[:page], 'chats_num', 5)
  end

  def list_all_groups
    @groups = Group.find_group_rank(params[:page], params[:sort])
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
      notice_stickie('更新成功')
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
          notice_stickie("開團成功")
          redirect_to :action => "show", :id => @group.id
        else
          error_stickie("開團失敗, 請重新在設定一次")
          render :action => 'new'
        end
      else
        error_stickie("開團失敗, 請重新在設定一次")
        render :action => 'new'
      end
    else
      warning_stickie("一個人限開一團, 請先退出你原本的團隊")
      redirect_to :action => "index"
    end
  end

  def join
    @group = Group.find(params[:id])
    if @group.get_in?(@me) && @me.change_group(@group)
      notice_stickie("加入成功")
      redirect_to :action => "show", :id => @group.id
    else
      warning_stickie("你已經有參加其他團了或者是團隊已滿")
      redirect_to :action => "index"
    end
  end

  def invite
    @group = Group.find(params[:id])
    if user = User.find_by_name(params[:user][:name])
      if @group.get_in?(user) && @group.owner == @me && user.change_group(@group)
        notice_stickie('加入完成')
        redirect_to :action => "show", :id => @group.id
      else
        warning_stickie("他已經有參加其他團了或者是團隊已滿")
        redirect_to :action => "index"
      end
    else
      error_stickie('沒有這個使用者喔')
      redirect_to :back
    end
  end

  def fire
    if params[:id] == @me.id
      warning_stickie('沒有在開除自己的啦')
    else
      @user = @me.own_group.members.find(params[:id])
      @user.change_group(nil, nil)
    end
    redirect_to :action => "list", :id => @me.own_group
  end

  def quit 
    if @me.own_group
      warning_stickie('必須把團長移交給其他人才可以退團')
    elsif @me.group
      @me.change_group(nil, nil)
    end

    redirect_to :action => "index"
  end

  def transfer
    if @user = @me.own_group.members.find_by_name(params[:user][:name])
      @group = @me.group
      @group.owner = @user
      @group.save

      notice_stickie('移交完成')
      redirect_to :action => "show", :id => @group.id
    else
      warning_stickie('沒有該名使用者或者該使用者不是本團團員')
      redirect_to :back
    end
  end

  def absence
    if params[:absence] == '1'
      notice_stickie('請假成功(沒來做紀錄將一直保持請假)')
      @me.status.update_attribute(:fight, false)
    else
      notice_stickie('已經取消請假狀態')
      @me.status.update_attribute(:fight, true)
    end
    redirect_to :action => "show", :id => params[:id]
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    notice_stickie('解散成功')
    redirect_to :action => "index"
  end

  def edit_member_title
    @user = @me.own_group.members.find(params[:id])
    if request.post?
      @user.update_attribute(:group_nickname, params[:user][:group_nickname])
      redirect_to :action => 'list', :id => @me.own_group
    end
  end

  def rank_list
    if request.post?
      date_from = Time.local(params[:from][:year], params[:from][:month], params[:from][:day])
      date_until = Time.local(params[:until][:year], params[:until][:month], params[:until][:day])
      date_until = 1.day.since(date_until)

      cond = date_range_cond(date_from, date_until)

      group = Group.find(params[:id])

      @rank = []
      group.members.each do |m|
        @rank << [m, m.count_score(cond)]
      end

      @rank.sort!{|x, y| y[1] <=> x[1] }
    end
  end

  private

  def date_range_cond(date_from, date_until)
    if date_from <=  date_until 
      from = date_from
      utl = date_until
    else
      from = date_until
      utl = date_from
    end
    return "todo_time <= '#{utl.to_s(:db)}' and todo_time >= '#{from.to_s(:db)}'"
  end

end

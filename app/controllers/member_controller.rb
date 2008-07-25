#handle record table
class MemberController < ApplicationController
  layout "application"
  before_filter :check_auth, :except =>[:show_today_results, :list, :list_all_records]
  before_filter :date_select, :only => [:list]
  before_filter :find_user, :except => [:show]
  helper :all

  def index
    redirect_to :controller => 'main', :action => 'index'
  end

  def new
    @record = Record.new
    render :layout => false
  end

  #create the records be forgot
  def create 
    params[:record][:state] = 1
    if @me.records.todo('wake_up', params[:record])
      flash[:info] = "設定完成"
    else
      flash[:notice] = "設定失敗, 已有紀錄, 或者設定了未來的時間喔= ="
    end

    redirect_to :controller => 'member', :action => 'list'
  end

  #destroy the record
  def destroy
    @me.records.find(params[:id]).destroy
    redirect_to :back
  end

  def show
    @record = Record.find(params[:id])
    @user = @record.user
    index = @record.all_records_id.index(params[:id].to_i)

    #第一筆大(小)於現在的時間
    #把條件存在session裡, 前一筆跟後一筆也是
    @next_record = @record.user.records.find(:first, :order => "id", :offset => index+1)
    unless index.zero?
      @previous_record = @record.user.records.find(:first, :order => "id", :offset => index-1)
    end
  end

  def list
    @records = @user.records.find_all_todo_time(@month, @year, "DESC", params[:page], 31)

    records = @user.records.find_all_todo_time(@month, @year)
    @time = Record.time_to_string(records, "todo_time")
    @target_time = Record.time_to_string(records, "todo_target_time")
  end

  def list_all_records
    @records = Record.find_all_records(params[:page])
  end

  def target_time_now
    if request.post?
      @me.target_time_now = target_time( params[:date][:hour], params[:date][:minute] )

      if @me.save
        flash[:info] = "設定完成"
        redirect_to :action => 'list'
      end
    else
      render :layout => false
    end
  end

  def wake_up
    if @me.today_record
      flash[:notice] = "沒有人一直在早起的啦"
      redirect_to :back
    else
      record = @me.records.create    
      if record.errors.empty?
        #@me.set_census
        flash[:info] = "早安喔, 可以寫一下給今日的話, 鼓勵一下自己喔"
      else
        flash[:notice] = "不能設定現在之後的時間喔"
      end

      redirect_to :controller => 'member', :action => 'list' 
    end 
  end

  def edit_time
    @record = @me.records.find(params[:id])
    render :layout => false
  end

  def write_diary
    @record = @me.records.find(params[:id])
    #@time = Time.now
    render :layout => false
  end

  def update
    @record = @me.records.find(params[:id])
    if @record.update_attributes(params[:record])
      if @record.save
        redirect_to :action => 'list'
      end
    else
      flash[:notice] = "你沒輸入內容啦"
      redirect_to :back
    end
  end

  def update_time
    @record = @me.records.find(params[:id])
    params[:record][:state] = 1
    if @record.update_attributes(params[:record])
      if @record.save
        redirect_to :action => 'list'
      end
    else
      flash[:notice] = "不能設定現在之後的時間喔"
      redirect_to :back
    end
  end

  private

  def date_select
    @month = month_selected
    @year = year_selected
  end

  def find_user
    begin
      @user = User.find(params[:id])
    rescue
      @user ||= @me
    end
  end
end

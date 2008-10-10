#handle record table
class MemberController < ApplicationController
  layout "application"
  before_filter :check_auth, :except =>[:show_today_results, :list, :list_all_records, :widget, :show, :pie_widget, :state_widget]
  before_filter :date_select, :only => [:list]
  before_filter :find_user, :except => [:show]

  before_filter :rand_word, :only => [:wake_up, :sleep, :create, :write_diary]
  before_filter :latest_diary, :only => [:wake_up, :sleep, :create, :write_diary]
  helper :all

  def index
    redirect_to :controller => 'main', :action => 'index'
  end

  def new
    @record = Record.new
    render :layout => false
  end

  def new_sleep
    @record = Record.new
    render :layout => false
  end

  #create the records be forgot
  def create 
    if params[:record]
      params[:record][:state] = 1 

      if params[:type] == 'sleep' && @record = @me.records.todo('sleep', params[:record])
        flash[:info] = "設定完成"
      elsif @record =  @me.records.todo('wake_up', params[:record])
        flash[:info] = "設定完成"
      else
        flash[:notice] = "設定失敗, 已有紀錄, 或者設定了未來的時間喔= ="
        redirect_to :action => 'list' and return
      end

      render :action => 'update'
    else
      redirect_to :action => 'list'
    end
  end

  #destroy the record
  def destroy
    @me.records.find(params[:id]).destroy
    redirect_to :back
  end

  def show
    @record = Record.find(params[:id])
    @user = @record.user
    #index = @record.all_records_id.index(params[:id].to_i)

    #第一筆大(小)於現在的時間
    #把條件存在session裡, 前一筆跟後一筆也是
    @next_record = @user.records.find(:first, :conditions => ["todo_time > ?", @record.todo_time])
    @previous_record = @user.records.find(:first, :conditions => ["todo_time < ?", @record.todo_time])

    Record.increment_counter(:readed, @record.id)
  end

  def list
    @records = @user.records.find_all_todo_time(@month, @year, "DESC")
    records = @user.records.find_all_todo_time(@month, @year, "", 'wake')
    sleep_records = @user.records.find_all_todo_time(@month, @year, "", 'sleep')

    @time = Record.time_to_string(records, "todo_time")
    @sleep_time = Record.time_to_string(sleep_records, "todo_time")
    @target_time = Record.time_to_string(records, "todo_target_time")
    @sleep_target_time = Record.time_to_string(sleep_records, "todo_target_time")

    @last_record = @user.records.last(:order => "todo_time")

    @friend_list = @user.friends.map{|u| [u.name, u.id]}
  end

  def list_all_records
    @records = Record.find_all_records(params[:page])
  end

  def target_time_now
    if request.post?
      @me.target_time_now = target_time(params[:date][:hour], params[:date][:minute])

      if @me.save
        flash[:info] = "設定完成"
        redirect_to :action => 'list'
      end
    else
      @targets = @me.targets.wake.find(:all, :order => 'week')
      render :layout => false
    end
  end

  def sleep_target_time
    if request.post?
      @me.sleep_target_time = target_time(params[:date][:hour], params[:date][:minute])

      if @me.save
        flash[:info] = "設定完成"
        redirect_to :action => 'list'
      end
    else
      @targets = @me.targets.sleep.find(:all, :order => 'week')
      render :layout => false
    end
  end

  def wake_up
    if @me.today_record
      flash[:notice] = "沒有人一直在早起的啦"
      redirect_to :back
    else
      begin 
        @record = @me.records.create(:todo_time => Time.parse(params[:time]))
      rescue Error => e
        logger.debug "DEBUG!! #{e}"
        @record = @me.records.create
      end

      if @record.errors.empty?
        flash[:info] = "早安喔, 可以寫一下給今日的話, 鼓勵一下自己喔"
      else
        flash[:notice] = "不能設定現在之後的時間喔"
      end

      render :action => 'update'
    end 
  end

  def sleep
    begin 
      @record = @me.records.create(:todo_name => 'sleep', :todo_time => Time.parse(params[:time]))
    rescue Error => e
      logger.debug "DEBUG!! #{e}"
      @record = @me.records.create(:todo_name => 'sleep')
    end

    if @record.errors.empty?
      flash[:info] = "晚安喔"
    else
      flash[:notice] = "不能設定現在之後的時間喔"
    end

    render :action => 'update'
  end

  def edit_time
    @record = @me.records.find(params[:id])
    render :layout => false
  end

  def write_diary
    @record = @me.records.find(params[:id])
    render :action => 'update'
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

  def update_words
    word = GreatWord.find('random')
    render :partial => 'word', :locals => {:word => word}
  end

  def widget
     user = User.find(params[:id])
     @content = render_to_string(:partial => 'census_widget', :locals => {:user => user}).to_json
     render :layout => false
     response.headers['Content-Type']='text/javascript'
  end

  def pie_widget
     user = User.find(params[:id])
     @content = render_to_string(:partial => 'pie_widget', :locals => {:user => user}).to_json
     response.headers['Content-Type']='text/javascript'
     render :action => 'widget', :layout => false
  end

  def state_widget
    user = User.find(params[:id])
    @content = render_to_string(:partial => 'state_widget', :locals => {:user => user}).to_json
    response.headers['Content-Type']='text/javascript'
    render :action => 'widget', :layout => false
  end

  def pie_widget_test1
     user = User.find(params[:id])
     @content = render_to_string(:partial => 'pie_widget', :locals => {:user => user}).to_json
     #response.headers['Content-Type']='text/javascript'
     render :action => 'widget', :layout => false, :content_type => 'text/javascript'
  end

  def pie_widget_test2
     user = User.find(params[:id])
     @content = render_to_string(:partial => 'pie_widget', :locals => {:user => user}).to_json
     #response.headers['Content-Type']='text/javascript'
     render :action => 'widget', :layout => false
  end

  def pie_widget_test3
     user = User.find(params[:id])
     @content = render_to_string(:partial => 'pie_widget', :locals => {:user => user})
     render :action => 'widget', :layout => false
  end

  def pie_widget_test4
     user = User.find(params[:id])
     @content = render_to_string(:partial => 'pie_widget', :locals => {:user => user})
     render :action => 'widget', :layout => false, :content_type => 'text/javascript'
  end

  def pie_widget_test5
     user = User.find(params[:id])
     @content = render_to_string(:partial => 'pie_widget', :locals => {:user => user})
     response.headers['Content-Type']='text/javascript'
     render :action => 'widget', :layout => false
  end

  def sparkline_widget
     user = User.find(params[:id])

     @content = render_to_string(:partial => 'sparkline_widget', :locals => {:user => user}).to_json
     response.headers['Content-Type']='text/javascript'
     render :action => 'widget', :layout => false
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
      redirect_to :controler => 'main', :action => 'index' and return false unless @user
    end
  end

  def latest_diary
    @latest_diary = Record.have_content.find(:all, :limit => 5, :order => 'id DESC')
  end

  def rand_word
    @word = GreatWord.find('random')
  end
end

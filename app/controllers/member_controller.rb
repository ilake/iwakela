#handle record table
class MemberController < ApplicationController
  uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:edit_journal, :wake_up, :sleep, :create, :new_journal])

  layout "application"
  before_filter :check_auth, :except =>[:show_today_results, :list, :list_all_records, :widget, :show, :pie_widget, :state_widget, :journal, :list_journal, :census, :night_journal, :todo, :daylight_journal]
  before_filter :date_select, :only => [:list, :census, :list_journal]
  before_filter :find_user, :except => [:show]

  before_filter :rand_word, :only => [:wake_up, :sleep, :create, :write_diary, :new_journal, :edit_journal]
  before_filter :latest_diary, :only => [:wake_up, :sleep, :create, :write_diary]

  before_filter :user_now, :only => [:journal, :night_journal]
  before_filter :user_today, :only => [:journal, :night_journal]

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
        notice_stickie("設定完成")
      elsif @record =  @me.records.todo('wake_up', params[:record])
        notice_stickie("設定完成")
      else
        error_stickie("設定失敗, 已有紀錄, 或者設定了未來的時間喔= =")
        redirect_to :action => 'list', :id => @me and return
      end

      render :action => 'update'
    else
      redirect_to :action => 'list', :id => @me
    end
  end

  #destroy the record
  def destroy
    @me.records.find(params[:id]).destroy
    if request.env["HTTP_REFERER"].blank?
      redirect_to :controller => 'member', :action => 'list'
    else
      redirect_to :back
    end
  end

  def show
    if @record = Record.find_by_id(params[:id])
      @user = @record.user
      t = @record.todo_time
      redirect_to :action => 'journal', :id => @user , :year => t.year, :month => t.month, :day => t.day
    else
      redirect_to :action => 'journal', :id => @user
    end
#
#    #第一筆大(小)於現在的時間
#    #把條件存在session裡, 前一筆跟後一筆也是
#    @next_record = @user.records.find(:first, :conditions => ["todo_time > ?", @record.todo_time])
#    @previous_record = @user.records.find(:first, :conditions => ["todo_time < ?", @record.todo_time])
#
#    Record.increment_counter(:readed, @record.id)
  end

  def list
    redirect_to :action => 'journal', :id => @user
#    @from, @to = month_range
#    @records = @user.records.find_all_todo_time(params[:page], @from, @to, "DESC")
#
#    records = @user.records.find_all_todo_time(params[:page], @from, @to, "", 'wake')
#    sleep_records = @user.records.find_all_todo_time(params[:page], @from, @to, "", 'sleep')
#
#    @time, @sleep_time, @target_time, @sleep_target_time = record_to_string(records, sleep_records)
#
#    @last_record = @user.records.last(:order => "todo_time")
#    @friend_list = @user.friends.map{|u| [u.name, u.id]}
  end

  def target_time_now
    if request.post?
      @me.target_time_now = target_time(params[:date][:hour], params[:date][:minute])

      if @me.save
        notice_stickie("設定完成")
#        redirect_to :action => 'list'
      end
#    else
#      @targets = @me.targets.wake.find(:all, :order => 'week')
#      render :layout => false
    end
    redirect_to :controller => 'user', :action => 'edit', :id => @me.id
  end

  def sleep_target_time
    if request.post?
      @me.sleep_target_time = target_time(params[:date][:hour], params[:date][:minute])

      if @me.save
        notice_stickie("設定完成")
        redirect_to :action => 'list'
      end
    else
      @targets = @me.targets.sleep.find(:all, :order => 'week')
      render :layout => false
    end
  end

  def wake_up
    if @me.today_record
      warning_stickie("沒有人一直在早起的啦")
      redirect_to :action => 'list'
    else
      begin 
        time = Time.now.since(@me.setting.time_offset.hours)
        @record = @me.records.create(:todo_time => time, :title => "#{time.to_s(:md)}日誌")
      rescue Exception => e
        logger.debug "DEBUG!! #{e}"
        @record = @me.records.create
      end

      if @record.errors.empty?
        notice_stickie("早安喔")
      else
        error_stickie("不能設定現在之後的時間喔")
      end

      if params[:style] == 'mobile'
        redirect_to :controller => 'mobile', :action => 'home' and return
      else
        render :action => 'update' and return 
      end
    end 
  end

  def sleep
    begin 
      time = Time.now.since(@me.setting.time_offset.hours)
      @record = @me.records.create(:todo_name => 'sleep', :todo_time => time, :title => "#{time.to_s(:md)}日誌")
    rescue Exception => e
      logger.debug "DEBUG!! #{e}"
      @record = @me.records.create(:todo_name => 'sleep')
    end

    if @record.errors.empty?
      notice_stickie("晚安喔")
    else
      error_stickie("不能設定現在之後的時間喔")
    end

    if params[:style] == 'mobile'
      redirect_to :controller => 'mobile', :action => 'home' and return
    else
      render :action => 'update'
    end

  end

  def edit_time
    @record = @me.records.find(params[:id])
    render :layout => false
  end

  def write_diary
    @record = @me.records.find(params[:id])
    render :action => 'update'
  end

  #圖, 資料統計類
  def census
    @from, @to = month_range
    @records = @user.records.find_all_todo_time(params[:page], @from, @to, "DESC")

    #@from, @to = thirty_days_ago_range(to)
    records = @user.records.find_all_todo_time(params[:page], @from, @to, "", 'wake')
    sleep_records = @user.records.find_all_todo_time(params[:page], @from, @to, "", 'sleep')

    @time, @sleep_time, @target_time, @sleep_target_time = record_to_string(records, sleep_records)

    @record_count = @user.records.count
    @diary_count =  @user.records.have_content.count

    @wake_target_time_array = Array.new(7, @user.target_time_now)
    @user.targets.wake.each do |t|
      @wake_target_time_array[t.week] = t.todo_target_time
    end

    @sleep_target_time_array = Array.new(7, @user.sleep_target_time)
    @user.targets.sleep.each do |t|
      @sleep_target_time_array[t.week] = t.todo_target_time
    end

    @last_record = @user.records.by_time.first
  end

  def list_journal
    day = Time.mktime(@year, @month, 1, 0, 0, 0).at_end_of_month.day

    @last_day = find_last_day(@year, @month, day)

    #@record_timeline, @downlimit_date  = make_record_timeline(@last_day, params[:day])
    @record_timeline, @downlimit_date  = make_record_timeline(@last_day, day)
    #@night_record_timeline, @night_downlimit_date  = make_record_timeline(@last_day, params[:day], :night)
    @night_record_timeline, @night_downlimit_date  = make_record_timeline(@last_day, day, :night)
  end

  def new_journal
    @realtime = true if params[:realtime]
    @type = params[:type] ? params[:type] : 'night'

    state = params[:realtime] ? '0' : '1'
    @record = Record.new(:todo_time => params[:todo_time], :pri => @me.setting.record_pri, :state => state)

    @daily_goals = @me.goals.no_once.by_rank.active
    @daily_giveup_goals = @me.goals.by_rank.giveup
    @daily_complete_goals = @me.goals.by_rank.complete
    @today_goals = @record.goal_details.by_rank if @record && @record.goal_details


    flash[:from], flash[:year], flash[:month] = params[:from], params[:year], params[:month] 
  end

  def edit_journal
    @record = @me.records.find(params[:id])

    @daily_goals = @me.goals.no_once.by_rank.active
    @daily_giveup_goals = @me.goals.by_rank.giveup
    @daily_complete_goals = @me.goals.by_rank.complete
    @today_goals = @record.goal_details.by_rank if @record && @record.goal_details

    flash[:from], flash[:year], flash[:month] = params[:from], params[:year], params[:month] 
  end


  def create_journal
    if params[:type] == 'night' && @record = @me.records.todo('sleep', params[:record])
      notice_stickie("完成")
    elsif @record =  @me.records.todo('wake_up', params[:record])
      notice_stickie("完成")
    else
      error_stickie("失敗, 標題是空的 再忙也要寫點東西喔")
      redirect_to :back and return
    end

    parse_hash_goal_to_user_goal(params[:item], @record) if params[:item]

    time = @record.todo_time
    if flash[:from] == 'list_journal'
      redirect_to member_url(:action => 'list_journal', :id => @me,
                             :year => flash[:year], :month => flash[:month])
    elsif params[:type] == 'night'
      redirect_to night_journal_url(:id => @me, :year => time.year, :month => time.month, :day => time.day)
    else
      redirect_to journal_url(:id => @me, :year => time.year, :month => time.month, :day => time.day)
    end
  end

  #日記
  def night_journal
    @last_day = if params[:record_id]
                  @record = @user.records.night.find(params[:record_id])
                  find_last_day(@record.todo_time.year, @record.todo_time.month, @record.todo_time.day)
                else
                  find_last_day(params[:year], params[:month], params[:day])
                end

    @record_timeline, @downlimit_date  = make_record_timeline(@last_day, 21, :night)
    #某天的日誌
    @record = make_diary(@last_day, :night) unless params[:record_id]
    @today_goals = @record.goal_details.by_rank if @record && @record.goal_details

    @today_target_time = @user.target_sleep_time
    @tomorrow_target_time = @user.target_sleep_time(Time.now.tomorrow)

    @latest_record_comments = @user.latest_record_comments
    @journal_status = 'night'
    render :action => 'journal'
  end

  def journal
    @last_day = if params[:record_id]
                  @record = @user.records.wake.find(params[:record_id])
                  find_last_day(@record.todo_time.year, @record.todo_time.month, @record.todo_time.day)
                else
                  find_last_day(params[:year], params[:month], params[:day])
                end

    @record_timeline, @downlimit_date  = make_record_timeline(@last_day, 21)
    #某天的日誌
    
    @record = make_diary(@last_day) unless params[:record_id]
    @today_goals = @record.goal_details.by_rank if @record && @record.goal_details

    @today_target_time = @user.target_time
    @tomorrow_target_time = @user.target_time(Time.now.tomorrow)

    @latest_record_comments = @user.latest_record_comments
    @journal_status = 'daylight'
  end

  def journal_comments
    @record_comments = @user.record_comments.paginate :include => [{:user => :mugshot}, :record],
      :page => params[:page], :per_page => 10
  end

  def daylight_journal
    redirect_to :action => 'journal'
  end

  #留言
  def messages
    redirect_to :controller => 'messages', :id => @user
  end

  #只秀todo
  def todo
    @goal_lists = @user.goals.by_rank.map{|g|[g.name, g.id]}

    params[:goal_id] ||= @goal_lists[0][1] unless @goal_lists.blank?

    @goal = Goal.find_by_id(params[:goal_id])
    if @goal
      cond = params[:done] ? {:conditions => {:done => params[:done] }} : {}
      @details =  @goal.goal_details.by_time.paginate cond.merge(:page => params[:page],:per_page => 20, :include => :record)
      @group_details = @details.group_by{|g| g.created_at.at_beginning_of_month}
      @details ||= []

      @total = @goal.goal_details.count
    end

    @daily_goals = @user.goals.no_once.by_rank.active
    @daily_goals ||= []

    @daily_giveup_goals = @user.goals.by_rank.giveup
    @daily_giveup_goals ||= []

    @daily_complete_goals = @user.goals.by_rank.complete
    @daily_complete_goals ||= []

    render :action => 'todo', :goal_id => params[:goal_id]
  end

  def update
    record = @me.records.find(params[:id])
    if params[:item]
      #params[:record][:hash_goal] = params[:item].to_json
      #檢查這個record 有沒有 這個item 裡面的 daily goal id 或者是 once , once 就是goal_id = nil
      #如果是once 就只能用名字去判斷, 相同的改 不同的create
      #
      #刪除時的用detail_id 去刪
      #create_goal_details(params[:item])
      parse_hash_goal_to_user_goal(params[:item], record)
    end

    if record.update_attributes(params[:record])
      time = record.todo_time
      if flash[:from] == 'list_journal'
        redirect_to member_url(:action => 'list_journal', :id => @me,
                               :year => flash[:year], :month => flash[:month])
      elsif record.todo_name == 'sleep'
        redirect_to night_journal_url(:id => @me, :year => time.year, :month => time.month, :day => time.day)
      else
        redirect_to journal_url(:id => @me, :year => time.year, :month => time.month, :day => time.day)
      end
    else
      warning_stickie("你沒輸入內容啦")
      redirect_to :back
    end
  end

  def push
    if p = @me.pushs.create(:record_id => params[:id])
      if p.errors.empty?
        Record.increment_counter(:push_count, params[:id])
        notice_stickie('推薦成功')
      else
        error_stickie('你已經推薦過此篇')
      end
    else
      error_stickie('你已經推薦過此篇')
    end

    redirect_to :back
  end

  def push_users
    if r = Record.find(params[:id])
      @users = r.pushs.include_users.map(&:user).paginate :page => params[:page], :per_page => 10, :include => [:mugshot, :profile]
      @num = r.pushs.count
      render :template => 'user/list'
    end
  end

  def cut_goal_total_val
    if g = Goal.find_by_id(params[:id])
      g.total = g.total - params['old_value'].to_f
      g.save
    end

    if gd = GoalDetail.find_by_id(params[:detail_id])
      gd.destroy
    end
    render :nothing => true, :status => 200
  end

  def update_time
    @record = @me.records.find(params[:id])
    params[:record][:state] = 1
    if @record.update_attributes(params[:record])
      if @record.save
        redirect_to :action => 'list'
      end
    else
      error_stickie("不能設定現在之後的時間喔")
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

  def edit_record_time
    record = @me.records.find(params[:id])
    if r = record.update_attributes(params[:record])
      render :update do |page|
        page.replace_html 'edit_remote_result', r.todo_time.to_s(:mdate)
        page.hide 'edit_time_form'
      end
    end
  end

  def set_graph_range
    if params[:startDate] || params[:endDate]
      from = Time.parse(params[:startDate].values.join('/'))
      to   = Time.parse(params[:endDate].values.join('/'))
    else
      params[:startDateInput] ||= Time.now.ago(1.month)
      params[:endDateInput] ||= Time.now

      from = Time.parse(params[:startDateInput])
      to  = Time.parse(params[:endDateInput])
    end

      paramters = {
        :order => "todo_time DESC",
        :conditions => ["todo_time >= ? and todo_time <= ?", from, to]
      }

      records = @user.records.wake.find(:all, paramters)
      sleep_records = @user.records.sleep.find(:all, paramters)
      @time, @sleep_time, @target_time, @sleep_target_time = record_to_string(records, sleep_records)


      render :update do |page|
        page.replace_html 'show_graph', :partial => "show_graph"
        page.hide 'remote_graph'
      end
  end

  def set_default_option
    session[params[:side_name].to_sym] = params[:side_status]
    render :nothing => true
  end

  def sparkline_widget
     user = User.find(params[:id])

     @content = render_to_string(:partial => 'sparkline_widget', :locals => {:user => user}).to_json
     response.headers['Content-Type']='text/javascript'
     render :action => 'widget', :layout => false
  end

  private

  def make_diary(date, type=:wake)
    record = @user.records.send(type).find(:first, :conditions => "records.todo_time >= '#{date.to_s(:db)}' AND records.todo_time < '#{date.tomorrow.to_s(:db)}'")
#    yesterday_record = @user.records.wake.find(:first, :conditions => "records.todo_time >= '#{date.yesterday.to_s(:db)}' AND records.todo_time < '#{date.to_s(:db)}'")

    return record
  end

  #method 1 one loop  0, 2, 5 ,10 ,21 依序檢查區間補上nil
  def make_record_timeline(uplimit_day=nil, line_size=nil, type=:wake)
    #設定default 值
    up_day = uplimit_day ? uplimit_day : user_today
    line   = line_size ? line_size : 21

    #timeline 第一天
    downlimit_date = up_day.ago((line - 1).days)

    uplimit = up_day.tomorrow
    downlimit = up_day.ago((line + 1).days)

    record_timeline = []
    records = @user.records.send(type).find(:all, :select => "id, title, todo_time, success, todo_name, state, content, user_id, pri", :order => 'todo_time', :conditions => ["todo_time > ? AND todo_time < ?", up_day.ago(line.days), uplimit])

    time_array = records
    time_array.unshift(Record.new(:todo_time => downlimit))
    time_array.push(Record.new(:todo_time => uplimit))

    time_array.each_index do |i|
      break if i == time_array.size - 1
      day_distance =  (time_array[i+1].todo_time.midnight - time_array[i].todo_time.midnight)/86400 - 1
      day_distance.to_i.times {record_timeline << nil}
      record_timeline << time_array[i+1]
    end
    record_timeline.delete_at(0)
    record_timeline.delete_at(-1)

    return record_timeline.reverse!, downlimit_date
  end

  def date_select
    @month ||= month_selected
    @year ||= year_selected
  end


  def latest_diary
    @latest_diary = Record.have_content.find(:all, :limit => 5, :order => 'id DESC')
  end

  def rand_word
    @word = GreatWord.find('random')
  end

  def record_to_string(records, sleep_records)
    time_shift = @user.setting.time_shift if @user
    time_shift ||= 3
    time = Record.time_to_string(records, "todo_time", time_shift)
    sleep_time = Record.time_to_string(sleep_records, "todo_time", time_shift)
    target_time = Record.time_to_string(records, "todo_target_time", time_shift)
    sleep_target_time = Record.time_to_string(sleep_records, "todo_target_time", time_shift)
    return time, sleep_time, target_time, sleep_target_time
  end

  def month_range
    month_selected = Time.local(@year, @month)
    month_next = month_selected.next_month
    return month_selected, month_next
  end

  def thirty_days_ago_range(now=Time.now)
    thirty_days_ago = now.ago(31.days)
    return thirty_days_ago, now
  end

  def find_last_day(year, month, day)
    if year && month && day
      Time.mktime(year, month, day, 0, 0, 0)
    else
      user_today 
    end
  end

  def parse_hash_goal_to_user_goal(hash_goal, record)
    hash_goal.each do |k, v|
      if v['goal_type'] == 'daily' && v['done'] == '1'
        if g = Goal.find_by_id(k)
          g.total = g.total - v['old_value'].to_f + v['value'].to_f
          g.save

          goal_id = g.id
        end
      elsif v['goal_type'] == 'daily' && !v['done']
        if g = Goal.find_by_id(k)
          g.total = g.total - v['old_value'].to_f
          g.save

          goal_id = g.id
        end
      elsif v['goal_type'] == 'once'
        goal_id = @user.goals.find_or_create_by_name('單次目標').id
      elsif k == 'once' 
        goal_id = @user.goals.find_or_create_by_name('單次目標').id

        v.values.each do |vv|
          goal_detail = record.goal_details.find_or_initialize_by_name(vv['name'])
          vv.merge!(:done => vv['done'], :goal_id => goal_id, :user_id => @user.id)
          goal_detail.attributes = vv
          goal_detail.save!
        end
      end
      
      if k != 'once'
        goal_detail = record.goal_details.find_or_initialize_by_name(v['name'])
        v.merge!(:done => v['done'], :goal_id => goal_id, :user_id => @user.id)
        goal_detail.attributes = v
        goal_detail.save!
      end
    end
  end
end

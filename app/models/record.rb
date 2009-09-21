# == Schema Information
# Schema version: 20090809070358
#
# Table name: records
#
#  id               :integer(4)      not null, primary key
#  todo_name        :string(255)     
#  todo_time        :datetime        
#  todo_target_time :datetime        
#  user_id          :integer(4)      not null
#  content          :text            
#  success          :boolean(1)      default(TRUE)
#  goal             :text            
#  com_goal         :text            
#  state            :integer(4)      
#  readed           :integer(4)      default(0)
#  feeling          :string(255)     
#  title            :string(255)     
#  content2         :text            
#  pri              :integer(4)      default(0)
#

#pri 0 是公開, 1是private
#state 0 是即時, 1是補上
class Record < ActiveRecord::Base
  include Common
  validates_presence_of :title
  belongs_to :user

  has_many :comments, :as => :record
  has_many :goal_details, :dependent => :destroy

  before_create :set_time
  before_create :set_todo_name
  before_create :set_target_time
  before_create :set_success, :if => Proc.new {|record| record.todo_name == 'wake_up'}
  before_update :set_success, :if => Proc.new {|record|  record.todo_name == 'wake_up' && record.todo_time_changed? }
  #如果編輯跑去編時間
  before_update :set_record_state, :if => Proc.new{|record| record.todo_time_changed?}


  after_save    :set_today_status_average_diff,  :if => Proc.new {|record| record.todo_name == 'wake_up' && record.todo_time_changed? }
  after_destroy :set_today_status_average_diff,  :if => Proc.new {|record|  record.todo_name == 'wake_up' }

  after_create :set_records_num_and_last_record_time
  after_destroy :set_records_num_and_last_record_time
  #after_create  :send_plurk_msg

  named_scope :success, :conditions => {:success => true}
  named_scope :fail, :conditions => {:success => false}
  named_scope :today, :conditions => "records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"
  named_scope :week, :conditions => ["todo_time > ?", Time.now.beginning_of_week]
  named_scope :wake, :conditions => {:todo_name => 'wake_up'}
  named_scope :daylight,  :conditions => {:todo_name => 'wake_up'}
  named_scope :sleep, :conditions => {:todo_name => 'sleep'}
  named_scope :night, :conditions => {:todo_name => 'sleep'}
  named_scope :by_time, :order => "todo_time DESC"
  named_scope :public, :conditions => {:pri => 0}

  named_scope :have_content, :conditions => "content is not NULL and content <> ''"
  has_many :pushs

  def set_time
    self.todo_time ||= Time.now
  end

  def set_todo_name
    self.todo_name ||= 'wake_up'
  end

  def set_target_time
    if todo_name == 'wake_up'
      self.todo_target_time ||= self.user.target_time(todo_time)
    elsif todo_name == 'sleep'
      self.todo_target_time ||= self.user.target_sleep_time(todo_time)
    end
  end

  def set_record_state
    self.state = '1'
  end

  def set_today_status_average_diff
    @user = self.user
    @status  = user.status
    #set_today_state 非統一做
    user.records.set_today_state(@status)

    #平均, 平均差雖然也是績效之一  可是沒來的不知道要怎樣算
    user.records.set_average(@status)
    user.records.set_diff_time(@status)


    #好像很多人習慣馬上知道起床數據, 所以只好再搬回來
    user.records.set_successful_rate(@status)
    user.records.set_continuous_num(@status, user)
    user.records.set_score(@status, user)

    true
  end

  #這是紀錄日誌總數
  def set_records_num_and_last_record_time
    @user ||= self.user
    @status  ||= user.status

    @user.records.set_records_num(@status)
    @user.records.set_last_record_time(@status)
    #砍日誌, goal 的次數也要重新算
    @user.goals.each do |goal|
      goal.total = goal.goal_details.be_done.sum(:value)
      goal.save!
    end
  end


  #只算最近21筆紀錄, 來算分數
  #def self.set_score(status, scores)
  def self.set_score(status, user)
    #最近21天的成功次數有多少
    success_count = self.wake.success.count(:all, :order => "id DESC", :conditions => "records.todo_time > '#{user.time_now.ago(21.days).at_beginning_of_day.to_s(:db)}'")
    total_score = success_count*4
    total_score = 100 if total_score > 100
    status.update_attribute(:score, total_score)
  end
  public

  #在status 那邊存最後一次紀錄的時間  用來在 User.find_user_no_records 做檢查
  def self.set_last_record_time(status)
    status.update_attribute(:last_record_created_at, self.find_last_day)
  end

  #在status 儲存 日誌總數
  def self.set_records_num(status)
    status.update_attribute(:num, self.count)
  end

  def self.set_today_state(status)
    #today_rec = self.wake.today.find(:first, :order => 'todo_time DESC')
    today_rec = self.wake.find(:first, :conditions => ["records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"], :order => 'todo_time DESC')
    if today_rec
      if today_rec.success
        status.update_attributes(:state => 1, :fight => true)
      else
        status.update_attributes(:state => 2, :fight => true)
      end
      # 如果今天有來, 表示取消請假狀態
      #status.update_attribute(:fight, true)
    else
      status.update_attributes(:state => 0)
    end
  end
  
  #平均只算最近的21 筆資料
  def self.set_average(status)
    average = self.count_average
    status.update_attribute(:average, average)
  end

  def self.set_diff_time(status)
    total = 0
    self.wake.find(:all, :conditions => "todo_target_time is not NULL", :limit => 21).each do |r|
      t = r.todo_target_time - r.todo_time
      if t < 0
        t *= -1
      end
      total += t
    end
    counts = self.wake.count(:all, :conditions => "todo_target_time is not NULL", :limit => 21)
    counts = 1 if counts.zero?
    diff = total/counts
    diff /= 60
    status.update_attribute(:diff, diff)
  end

  def self.set_successful_rate(status)
    records_success_percent = self.find_success_percent
    status.update_attribute(:success_rate, records_success_percent)
  end

  def self.set_continuous_num(status, user)
    last_success = self.wake.success.by_time.first
    #最後一次 沒來或最後一次失敗來當最後失敗的時間
    #今天到第一筆紀錄的日子不等於紀錄數  就表示中間有缺
    #兩筆紀錄時間超過兩天就表示有紀錄沒寫
    last_fail = self.wake.fail.by_time.first

    all_days = last_success ? Common.cal_days_interval(last_success.todo_time, user.time_now) : 0
    #沒來的就算晚起
    if all_days > 1
      num = -1*(all_days-1)
    elsif last_fail.nil?
      num = self.wake.count
    elsif last_success.nil? 
      num = self.wake.count*-1
    elsif last_fail.todo_time > last_success.todo_time
      num = self.find_continuous_num(last_success, last_fail)*-1
    else
      num = self.find_continuous_num(last_fail, last_success)
    end

    status.update_attribute(:continuous_num, num)
  end


  def send_plurk_msg
    services = self.user.service_profiles.find(:all)
    services.each do |s|
      case s.service
      when 'plurk'
        system "rake send_plurk RAILS_ENV=#{Rails.env} SERVICE_ID=#{s.id} RECORD_ID=#{self.id} &"
      end
    end
  end

  #把user 設定的 X:20分 弄成 X:20分59秒
  def set_success
    unless self.todo_target_time.blank?
      self.success = self.todo_time > self.todo_target_time.since(59.seconds) ? false : true
    else
      self.success = true 
    end
    true # why this
  end
  
  def self.todo(name, params=nil)
    params[:todo_name] = name
    record = self.new(params)
    record if record.save
  end

  def self.find_last_day
    if time = self.find(:first, :order => 'todo_time DESC')
      time.todo_time.at_beginning_of_day
    end
  end

  def lastest_target_time
    first(:order =>'id DESC').todo_target_time
  end

  #make array to string
  #[[2008, 11, 5, 30.0], [2008, 11, 6, 2.0] => "[[2008, 11, 5, 30.0], [2008, 11, 6, 2.0]]"
  def self.time_to_string(records, time_type, time_shift=3)
    time = ""

    if time_type == "todo_time"
      records.each do |record|
        todo_time = record.todo_time
        if todo_time.hour <= time_shift
          time << "[#{todo_time.to_i*1000}, #{24 + todo_time.hour + todo_time.min/60.0}],"
        else
          time << "[#{todo_time.to_i*1000}, #{todo_time.hour + todo_time.min/60.0}],"
        end
      end
    else
      records.each do |record|
        target_time = record.todo_target_time
        if target_time
          if target_time.hour <= time_shift
            time << "[#{target_time.to_i*1000}, #{24 + target_time.hour + target_time.min/60.0}],"
          else
            time << "[#{target_time.to_i*1000}, #{target_time.hour + target_time.min/60.0}],"
          end
        end
      end
    end
    time.chop!
    "[#{time}]"
  end

  def self.find_all_todo_time(page, date_from, date_to, option ="", type=nil)

    params = {
      :order => "todo_time #{option}", 
      :conditions => ["todo_time >= ? and todo_time <= ?", date_from, date_to]
    }

    if type.blank?
      #self.paginate params.merge!(:page => page, :per_page => 31, :include => :comments)
      find(:all, params.merge!(:include => :comments))
    elsif type == 'sleep'
      sleep.find(:all, params)
    else
      wake.find(:all, params)
    end
  end

  def self.find_success_percent
    records_success = self.wake.success.count
    if self.wake.first
      all_days = Common.cal_days_interval(self.wake.first.todo_time, Time.now)
      100*(records_success / all_days.to_f)
    else
      0
    end
  end

  def self.find_all_wake_up_today(params, res='none', per_page=10)
    cond = "records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"

    unless res == 'none'
      cond << "and records.success = #{res}" 
    end

    self.wake.public.paginate :page => params,
                  :per_page => per_page,
                  :include => [:user, {:user => :mugshot}],
                  :conditions => cond
  end

  def self.find_yesterday_records
    self.wake.find(:all, :conditions => ["content is not NULL and todo_time > ?", Time.now.midnight.yesterday],
                    :limit => 5)
  end

  def self.find_continuous_num(start_time, end_time)
    self.wake.count(:conditions => ["todo_time > ? and todo_time < ?", start_time.todo_time, end_time.todo_time])+1
  end

  def self.weekly_report
    users = User.find(:all)
    num = 0
    users.each_with_index do |u, i|
      if i%50 == 0 and i != 0
        Kernel.sleep(300)
      end
      EbMail.deliver_weekly_report(u)
    end
  end
  
  def self.find_week_record
    record = self.wake.find(:all, :conditions => ["todo_time > ?", Time.now.beginning_of_week])
    average = self.count_average(false)
    return record, average
  end

  def self.count_average(total=true)
    if total 
      times = self.wake.find(:all, :limit => 21, :order => 'todo_time DESC').map(&:todo_time)
    else
      times = self.wake.find(:all, :conditions => ["todo_time > ?", Time.now.beginning_of_week]).map(&:todo_time)
    end

    if times.blank?
      average = Time.mktime( 1982, 1, 8, 0, 0, 0)
    else
      hours = 0
      minutes= 0

      times.each do |t|
        hours = hours + t.hour
        minutes = minutes + t.min
      end
      total_sec = hours.hour + minutes.minute
      counts = times.size

      #一天起床時間有多少秒
      day_sec = total_sec/counts

      hour = day_sec/3600
      min = (day_sec-hour.hour)/60

      #average = Time.zone.local( 1982, 1, 8, hour, min, 0)
      average = Time.mktime( 1982, 1, 8, hour, min, 0)
    end
  end

  def all_records_id
    user.records.map(&:id)
  end

  def status_desc
    success ? I18n.t('record.success_status') : I18n.t('record.fail_status') 
  end

  private
#  先用單純的算法, 21天內成功幾次就幾分
#  def self.count_total_score(array, cont_count)
#    total = array.size
#    cont_count ||= -1000
#
#    array.delete(false)
#    success_count = array.size
#    fail_count = total - success_count
#    if cont_count >= 0 
#      cont_count = cont_count > total ? total : cont_count
#    else
#      cont_count = cont_count.abs > total ? total*-1 : cont_count
#    end
#
##42, -63
##  -10 0 10 20 30 40  
#    success_score = success_count + cont_count
#    fail_score = fail_count * 2
#
#    total_score = success_score - fail_score
#  end
end

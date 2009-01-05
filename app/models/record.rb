# == Schema Information
# Schema version: 20081227162431
#
# Table name: records
#
#  id               :integer(11)     not null, primary key
#  todo_name        :string(255)     
#  todo_time        :datetime        
#  todo_target_time :datetime        
#  user_id          :integer(11)     not null
#  content          :text            
#  success          :boolean(1)      default(TRUE)
#  goal             :text            
#  com_goal         :text            
#  state            :integer(11)     
#  readed           :integer(11)     default(0)
#

class Record < ActiveRecord::Base
  belongs_to :user

  has_many :comments, :as => :record

  before_create :set_time
  before_create :set_todo_name

  before_create :set_target_time

  before_create :set_success

  after_save    :set_census, :conditions => {:todo_name => 'wake_up'}
  after_destroy :set_census, :conditions => {:todo_name => 'wake_up'}
  before_update :set_success

  before_update :record_valid?, :conditions => {:todo_name => 'wake_up'}
  before_update :content_null?

  named_scope :success, :conditions => {:success => true}
  named_scope :fail, :conditions => {:success => false}
#  named_scope :today,
#              :conditions => ["todo_time > ? AND todo_time < ?", Time.now.midnight.to_s(:db), Time.now.tomorrow.midnight.to_s(:db)]

  named_scope :today,
    :conditions => "records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"
#  named_scope :today,
#              :conditions => ["todo_time > ? AND todo_time < ?", Time.now.midnight, Time.now.tomorrow.midnight]
  named_scope :week, :conditions => ["todo_time > ?", Time.now.beginning_of_week]
  named_scope :wake, :conditions => {:todo_name => 'wake_up'}
  named_scope :sleep, :conditions => {:todo_name => 'sleep'}

  named_scope :have_content, :conditions => "content is not NULL"

  #validates_length_of :content, :minimum => 1, :on => :update
  #after_create :set_average, :set_continuous_num, :set_successful_rate
  #acts_as_ferret :fields => [:content]

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

  def set_census
    user = self.user
    status  = user.status
    scores = user.scores
    user.records.set_average(status)
    user.records.set_successful_rate(status)
    user.records.set_continuous_num(status)
    user.records.set_today_state(status)
    user.records.set_records_num(status)
    user.records.set_last_record_time(status)
    user.records.set_diff_time(status)
    user.records.set_score(status, scores)
    true
  end

  #只算最近21筆紀錄, 來算分數
  def self.set_score(status, scores)
    total = self.wake.count
    total = total > 21 ? 21 : total

    a = self.wake.find(:all, :order => "id DESC", :limit => total).map(&:success)
    cont_count = status.continuous_num
    
    total_score = Record.count_total_score(a, cont_count)
    status.update_attribute(:score, total_score)
  end

  private
  def self.count_total_score(array, cont_count)
    total = array.size
    cont_count ||= -1000

    array.delete(false)
    success_count = array.size
    fail_count = total - success_count
    if cont_count >= 0 
      cont_count = cont_count > total ? total : cont_count
    else
      cont_count = cont_count.abs > total ? total*-1 : cont_count
    end

#42, -63
#  -10 0 10 20 30 40  
    success_score = success_count + cont_count
    fail_score = fail_count * 2

    total_score = success_score - fail_score
  end
  public

  def self.set_last_record_time(status)
    status.update_attribute(:last_record_created_at, self.find_last_day)
  end

  def self.set_records_num(status)
    status.update_attribute(:num, self.count)
  end

  def self.set_today_state(status)
    #today_rec = self.wake.today.find(:first, :order => 'todo_time DESC')
    today_rec = self.wake.find(:first, :conditions => ["records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"], :order => 'todo_time DESC')
    if today_rec
      if today_rec.success
        status.update_attribute(:state, 1)
      else
        status.update_attribute(:state, 2)
      end
      # 如果今天有來, 表示取消請假狀態
      status.update_attribute(:fight, true)
    else
      status.update_attribute(:state, 0)
    end
  end
  
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

  def self.set_continuous_num(status)
    last_success = self.find_last_success
    last_fail = self.find_last_fail

    if last_fail.nil?
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

  public

#  def self.count_score
#    total = self.count
#    total = total > 21 ? 21 : total
#
#    a = self.find(:all, :order => "id DESC", :limit => 21)
#    a.delete(false)
#    wake_count = a.size
#    sleep_count = total - wake_count
#
#    wake_score = wake_count * user.scores.find_by_name('wake').value
#    sleep_score = sleep_count * user.scores.find_by_name('sleep').value
#
#    total_score = wake_score - sleep_score 
#    user.status.update_attribute(:score, total_score)
#  end

  def set_success
    unless self.todo_target_time.blank?
      self.success = self.todo_time > self.todo_target_time ? false : true
    else
      self.success = true 
    end
    true # why this
  end
  
  def self.todo(name, params=nil)
    params[:todo_name] = name
    record = self.new(params)

    if name == 'wake_up'
      if record.record_valid?
        if record.save
          record
        end
      end
    else
      if record.save
        record
      end
    end
  end

  def self.find_last_day
    if time = self.find(:first, :order => 'todo_time DESC')
      time.todo_time.at_beginning_of_day
    end
  end

  def record_valid?
    time = self.todo_time
    if time > Time.now
      false
    elsif self.user.records.wake.find(:all, :conditions => ['todo_time < ? and todo_time > ?', time.tomorrow.at_beginning_of_day, time.at_beginning_of_day]).blank?
      true 
    end
  end

  def content_null?
    self.content = nil if self.content.blank?
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
    records_all = self.wake.count 
    records_all = 1 if records_all.zero?
    100*(records_success / records_all.to_f)
  end

  def self.find_all_wake_up_today(params, res='none', per_page=10)
    cond = "records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"

    unless res == 'none'
      cond << "and records.success = #{res}" 
    end

    self.wake.paginate :page => params,
                  :per_page => per_page,
    #              :include => [:user, {:user => :mugshot}],
                  :conditions => cond
  end

  def self.find_yesterday_records
    self.wake.find(:all, :conditions => ["content is not NULL and todo_time > ?", Time.now.midnight.yesterday],
                    :limit => 5)
  end

  def self.find_last_success
    self.wake.success.find(:first, :order => 'todo_time DESC')
  end

  def self.find_last_fail
    self.wake.fail.find(:first, :order => 'todo_time DESC')
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
  
  def self.lake_report
    u= User.find_by_email('lake.ilakela@gmail.com')
#    600.times do |i|
#      if i%50 == 0 and i != 0
#        Kernel.sleep(180)
#      end
      email = EbMail.create_weekly_report(u)
      EbMail.deliver(email)
#    end
#    email.set_content_type("text/html")
  end

  def self.test_sleep
    5.times do |i| Kernel.sleep(i); puts i;  end
#    a = []
#    600.times do |i|
#      if i%60 == 0 and i != 0
#        puts a.inspect
#        a.clear
#        sleep(60)
#      end
#      a << i
#    end
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

end

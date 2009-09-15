desc 'calculate performance'
namespace :cal do 
  task :performance => :environment do 
    #state 4 是太久沒來的, 每天在reset_all_state rake 裡做更新
    User.find(:all, :include => :status, :conditions => "statuses.state <> 4").each do |user|
      status  = user.status

      #下面算績效的統一做
      #平均雖然也是績效之一  可是沒來的不知道要怎樣算, 所以搬回record 存 wake_up的時候算
      #user.records.set_average(status)
      user.records.set_successful_rate(status)
      user.records.set_continuous_num(status, user)

      #搬回record 存時算     
      #user.records.set_records_num(status)
      #user.records.set_last_record_time(status)
      #user.records.set_diff_time(status)
      user.records.set_score(status, user)
    end
  end
end

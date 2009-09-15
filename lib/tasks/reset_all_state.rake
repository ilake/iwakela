desc 'reset_all_state'
namespace :cal do
  task :reset_state => :environment do
    #最近一個月都沒紀錄的fight 設成false, state 設成4
    User.find(:all).each do |u|
      if u.status.last_record_created_at 
        if u.status.last_record_created_at > Time.now.ago(1.month)
          u.status.update_attribute(:fight, true)
        else
          u.status.update_attribute(:fight, false)
          u.status.update_attribute(:state, 4)
        end
      else
        u.status.update_attribute(:fight, false)
      end
    end

    #因為fight false 也有可能是請假的
    Status.update_all("state = 0", "fight = true")
    Status.update_all("state = 3", "fight = false && state <> 4")
    Game.update_all("today_num = 0")
  end
end

#!/usr/bin/env script/runner
#校正goal total
user_id = ARGV[0]

User.find(user_id).goals.each do |goal|
  goal.total = goal.goal_details.be_done.sum(:value)
  goal.save!
end

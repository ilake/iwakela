class AddUserDefaultScore < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |u|
      u.scores.create(:name => 'wake', :value => 1)
      u.scores.create(:name => 'sleep', :value => 2)

      #status  = u.status
      #scores = u.scores
      #u.records.set_score(status, scores)
    end
  end

  def self.down
  end
end

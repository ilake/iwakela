class AddForumLastCommentGroupUserCount < ActiveRecord::Migration
  def self.up
    #add_column :forums, :last_comment_time, :datetime
    #add_column :groups, :members_count, :integer
    #rename_column :groups, :readed, :chats_num

    Forum.all.each do |f|
      if f.comments && f.comments.last
        f.last_comment_time = f.comments.last.created_at
        f.save!
      end
    end

    Group.all.each do |g|
      g.members_count = g.members.count
      g.save
    end

    Group.count_7_days_chats_num
  end

  def self.down
    remove_column :forums, :last_comment_time
    remove_column :groups, :members_count
    rename_column :groups, :chats_num, :readed
  end
end

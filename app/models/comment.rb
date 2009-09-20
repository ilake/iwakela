# == Schema Information
# Schema version: 20090809070358
#
# Table name: comments
#
#  id          :integer(4)      not null, primary key
#  created_at  :datetime        
#  content     :text            
#  record_id   :integer(4)      not null
#  record_type :string(255)     
#  user_id     :integer(4)      
#

class Comment < ActiveRecord::Base
  validates_presence_of :content
  belongs_to :record, :polymorphic => true
  belongs_to :user

  named_scope :valid, :conditions => "comments.user_id is not NULL"
  named_scope :by_time, :order => "created_at"

  after_save :add_forum_comment_count

  def add_forum_comment_count
    if self.record_type == 'Forum'
      self.record.comments_count+=1
      self.record.save!
    end
  end
end

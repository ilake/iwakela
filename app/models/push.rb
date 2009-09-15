#儲存誰替某篇日誌推薦過
class Push < ActiveRecord::Base
  belongs_to :user
  belongs_to :record

  validates_uniqueness_of :user_id, :scope => :record_id

  named_scope :include_users, :include => :user
end

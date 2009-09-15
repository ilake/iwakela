# == Schema Information
# Schema version: 20090809070358
#
# Table name: mugshots
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)      
#  created_at   :datetime        
#  parent_id    :integer(4)      
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(4)      
#  width        :integer(4)      
#  height       :integer(4)      
#  group_id     :integer(4)      
#

class Mugshot < ActiveRecord::Base
  has_attachment :content_type => :image, 
    :storage => :file_system, 
    :resize_to => '100x100>',
    :thumbnails => { :medium => '60x60>', :small => '30x30>' }

  validates_as_attachment

  belongs_to :user
  belongs_to :group
end

# == Schema Information
# Schema version: 20080819065738
#
# Table name: mugshots
#
#  id           :integer(11)     not null, primary key
#  user_id      :integer(11)     
#  created_at   :datetime        
#  parent_id    :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#

class Mugshot < ActiveRecord::Base
  has_attachment :content_type => :image, 
    :storage => :file_system, 
    :resize_to => '100x100>',
    :thumbnails => { :medium => '60x60>', :small => '30x30>' }

  validates_as_attachment

  belongs_to :user
end

class Mugshot < ActiveRecord::Base
  has_attachment :content_type => :image, 
    :storage => :file_system, 
    :resize_to => '125x125>',
    :thumbnails => { :small => '24x24>' }

  validates_as_attachment

  belongs_to :user
end

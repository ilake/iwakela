class Mugshot < ActiveRecord::Base
  has_attachment :content_type => :image, 
    :storage => :file_system, 
    :resize_to => '125x125>',
    :thumbnails => { :medium => '60x60>', :small => '30x30>' }

  validates_as_attachment

  belongs_to :user
end

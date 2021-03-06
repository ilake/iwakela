# == Schema Information
# Schema version: 20090809070358
#
# Table name: calls
#
#  id          :integer(4)      not null, primary key
#  demander_id :integer(4)      
#  accepter_id :integer(4)      
#  title       :string(255)     
#  time        :datetime        
#

class Call < ActiveRecord::Base
  belongs_to :demander, :foreign_key => 'demander_id', :class_name => 'User'
  belongs_to :accepter, :foreign_key => 'accepter_id', :class_name => 'User'

  has_many :comments, :as => :record
end

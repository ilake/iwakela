# == Schema Information
# Schema version: 20081227162431
#
# Table name: great_words
#
#  id      :integer(11)     not null, primary key
#  content :text            
#  user_id :integer(11)     
#

class GreatWord < ActiveRecord::Base
  belongs_to :user
  HUMANIZED_ATTRIBUTES = {
    :content => "內容"
  }

  validates_presence_of :content

  def self.find(*args)
    scope = args.first
    if scope.to_s == "random"
      super :first, :offset => (rand count).to_i
    elsif scope.to_s == "public"
      # blah, blah...
    else
      super
    end
  end
end

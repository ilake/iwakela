class Talk < ActiveRecord::Base
  belongs_to :game
  validates_presence_of :name, :content

  def self.paginator(params, per_page=20)
    self.paginate :page => params,
                  :per_page => per_page,
                  :order => 'created_at DESC'
  end
end

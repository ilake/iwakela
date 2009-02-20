class AddCommentsRecordType < ActiveRecord::Migration
  def self.up
    add_column :comments, :record_type, :string

#    Comment.find(:all).each do |c|
#      c.update_attribute(:record_type, 'Record')
#    end
  end

  def self.down
    remove_column :comments, :record_type
  end
end

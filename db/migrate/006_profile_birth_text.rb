class ProfileBirthText < ActiveRecord::Migration
  def self.up
    change_column :profiles, :birth, :text
  end

  def self.down
    change_column :profiles, :birth, :datetime
  end
end

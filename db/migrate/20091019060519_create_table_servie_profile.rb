class CreateTableServieProfile < ActiveRecord::Migration
  def self.up
    create_table :service_profiles do |t|
      t.belongs_to :user
      t.string :service, :name, :password
    end
  end

  def self.down
    drop_table :service_profiles
  end
end

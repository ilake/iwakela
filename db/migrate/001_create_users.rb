class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name, :string
      t.column :password_salt, :string
      t.column :password_hash, :string
      t.column :email, :string
      t.column :created_at, :datetime      
      t.column :cookie_hash, :string
      t.column :target_time_now, :datetime
      t.column :reset_password_code, :string
      t.column :reset_password_code_until, :datetime
      t.column :yahoo_userhash, :string
    end
  end

  def self.down
    drop_table :users
  end
end

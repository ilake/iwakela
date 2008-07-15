class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column :user_id, :integer
      t.column :others, :text
      t.column :sex, :string
      t.column :birth, :datetime
      t.column :star, :string
      t.column :blood, :string
      t.column :address, :string
      t.column :school, :string
      t.column :job, :string
      t.column :interest, :string
      t.column :photo, :string
      t.column :connect, :string
      t.column :email_weekly, :boolean, :default => true
      t.column :average, :datetime
      t.column :success_rate, :integer
      t.column :continuous_num, :integer
    end
  end

  def self.down
    drop_table :profiles
  end
end

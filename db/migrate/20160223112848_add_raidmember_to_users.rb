class AddRaidmemberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :raidmember, :integer
  end
end

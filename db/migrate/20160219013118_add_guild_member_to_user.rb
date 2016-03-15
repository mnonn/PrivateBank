class AddGuildMemberToUser < ActiveRecord::Migration
  def change
    add_column :users, :guild_member, :integer
  end
end

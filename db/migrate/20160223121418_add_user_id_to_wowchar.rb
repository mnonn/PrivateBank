class AddUserIdToWowchar < ActiveRecord::Migration
  def change
    add_column :wowchars, :user_id, :integer
  end
end

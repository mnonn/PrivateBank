class CreateLootquotients < ActiveRecord::Migration
  def change
    create_table :lootquotients do |t|
      t.integer :raids_participated
      t.integer :loot
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

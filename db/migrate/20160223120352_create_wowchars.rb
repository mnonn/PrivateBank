class CreateWowchars < ActiveRecord::Migration
  def change
    create_table :wowchars do |t|
      t.string :name
      t.string :faction
      t.string :classname
      t.string :race
      t.integer :level

      t.timestamps null: false
    end
  end
end

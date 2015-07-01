class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.integer :mining_xp, default: 1
      t.integer :harvesting_xp, default: 1
      t.decimal :energy, maximum: 16, precision: 4, scale: 2, default: 7
      t.boolean :status, default: true
      t.decimal :distance_travelled, precision: 2, scale: 2, default: 0
      t.integer :minerals_mined, default: 0
      t.integer :food_harvested, default: 0
      t.belongs_to :stockpile
      t.timestamps null: false
    end
  end
end

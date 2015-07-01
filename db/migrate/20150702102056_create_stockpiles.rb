class CreateStockpiles < ActiveRecord::Migration
  def change
    create_table :stockpiles do |t|
      t.integer :mineral_count, default: 0
      t.integer :food_count, default: 0
      t.timestamps null: false
    end
  end
end

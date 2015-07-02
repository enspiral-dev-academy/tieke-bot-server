class CreateStockpiles < ActiveRecord::Migration
  def change
    create_table :stockpiles do |t|
      t.integer :mineral_count, default: 200
      t.integer :food_count, default: 200
      t.timestamps null: false
    end
  end
end

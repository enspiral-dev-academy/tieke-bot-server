Stockpile.destroy_all
Bot.destroy_all

stockpile = Stockpile.create(mineral_count: 200, food_count: 200)

10.times do
  bot = Bot.create(stockpile_id: stockpile.id)
end
Stockpile.destroy_all
Bot.destroy_all

stockpile = Stockpile.create(mineral_count: 200, food_count: 200)

10.times do
  bot = Bot.create()
  bot.stockpile = stockpile
  bot.save
end
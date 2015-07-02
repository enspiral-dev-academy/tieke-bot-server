get '/bots' do
  json Bot.all
end

get '/bots/:id' do
  json Bot.find(params[:id])
end

post '/bots' do
  stockpile = Stockpile.first
  bot = Bot.create(stockpile_id: stockpile.id)
  json [bot, stockpile]
end

get '/stockpile' do
  json Stockpile.first
end

post '/stockpile' do
  Stockpile.destroy_all
  stockpile = Stockpile.create()
  Bot.all.each {|bot| bot.stockpile_id = stockpile.id} unless Bot.all.empty?
  json stockpile
end

post '/bots/:id/mine' do
  bot = Bot.find(params[:id])
  bot.mine(params[:x].to_i, params[:y].to_i)
  json bot
end

post '/bots/:id/harvest' do
  bot = Bot.find(params[:id])
  bot.harvest(params[:x].to_i, params[:y].to_i)
  json bot
end

post '/bots/:id/feed' do
  bot = Bot.find(params[:id])
  stockpile = Stockpile.first
  bot.eat(params[:food_amount].to_f)
  [bot, stockpile].map { |js| json js }
end
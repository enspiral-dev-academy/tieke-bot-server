get '/bots' do
  json Bot.all
end

get '/bots/:id' do
  json Bot.find(params[:id])
end

post '/bots' do
  bot = Bot.create()
  stockpile = current_stockpile
  json [bot, stockpile].map { |js| JSON[js] }
end

get '/stockpile' do
  json Stockpile.first
end

post '/stockpile' do
  stockpile = Stockpile.create()
  session[:stockpile_id] = stockpile.id
end

post '/bots/:id/mine' do
  bot = Bot.find(params[:id])
  bot.mine(params[:x], params[:y])
  json bot
end

post '/bots/:id/harvest' do
  bot = Bot.find(params[:id])
  bot.harvest(params[:x], params[:y])
  json bot
end

post '/bots/:id/feed' do
  bot = Bot.find(params[:id])
  bot.eat(params[:food_amount])
  json bot
end
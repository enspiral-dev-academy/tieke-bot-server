require 'spec_helper'

describe "BotServerController" do

let (:stockpile) { Stockpile.create(mineral_count: 200, food_count: 200) }
let (:bot) { Bot.create(stockpile_id: @stockpile.id) }

before do
  Bot.destroy_all
  Stockpile.destroy_all
end

  describe "GET '/'" do
    it "returns status code 200" do
      get '/'
      expect(last_response.status).to eq(200)
    end

  describe "GET '/bots'" do
    it "returns status code 200" do
      get '/bots'
      expect(last_response.status).to eq(200)
    end

    it "returns all the bots as json" do
      @stockpile = stockpile
      @bot = bot
      get '/bots'
      expect(last_response.body).to eq(Bot.all.to_json)
    end
  end

  describe "POST '/bots/:id/feed'" do
    it "returns the bot with increased energy level as json" do
      @stockpile = stockpile
      @bot = bot
      post "/bots/#{@bot.id}/feed", {"food_amount" => 5}
      @bot = Bot.find(@bot.id)
      expect(last_response.body).to eq(@bot.to_json)
    end
  end

  describe "POST '/bots'" do
    it "returns the newly created bot and stockpile info as json" do
      @stockpile = stockpile
      post '/bots'
      @bot = Bot.last
      expect(last_response.body).to eq([@bot, @stockpile].map { |js| JSON.parse(js.to_json) })
      # expect(last_response.body).to eq([@bot, @stockpile].to_json)
    end
  end

end


end

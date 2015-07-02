require 'spec_helper'

describe "BotServerController" do

let (:stockpile) { Stockpile.create(mineral_count: 200, food_count: 200) }
let (:bot) { Bot.create(stockpile_id: @stockpile.id) }

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

  end


end

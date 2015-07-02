require 'httparty'
require 'logger'

class Bot < ActiveRecord::Base
  belongs_to :stockpile

  after_create do
    self.stockpile.mineral_count -= 8
  end

  def harvest(x, y)
      decrement_energy_level(x, y)
    if x.between?(1,10) && y.between?(1,10) && self.alive?
      response = HTTParty.post("https://tieke-landscape-server.herokuapp.com/harvest?x=#{x}&y=#{y}&bot_harvesting_xp=#{self.harvesting_xp}")
      response = JSON.parse(response)
      increment_food_harvested(response["food_harvested"])
      add_to_stockpile("food_count", response["food_harvested"])
      increment_h_xp(response["food_harvested"])
      increment_distance_travelled(x, y)
    end
  end

  def mine(x, y)
      decrement_energy_level(x, y)
    if x.between?(1,10) && y.between?(1,10) && self.alive?
      p "***************************************************"
      p response = HTTParty.post("https://tieke-landscape-server.herokuapp.com/mine?x=#{x}&y=#{y}&bot_mining_xp=#{self.mining_xp}")
      p "***************************************************"
      p response = JSON.parse(response)
      increment_minerals_mined(response["minerals_mined"])
      add_to_stockpile("mineral_count", response["minerals_mined"])
      increment_m_xp(response["minerals_mined"])
      increment_distance_travelled(x, y)
    end
  end

  def eat(food)
    self.stockpile.food_count -= increment_energy_level(food)
    self.stockpile.save
  end

  def add_to_stockpile(resource_count, amount)
    if resource_count == "mineral_count"
      self.stockpile.mineral_count += amount
    else
      self.stockpile.food_count += amount
    end
    self.stockpile.save
  end

  def increment_m_xp(minerals)
    self.mining_xp += (0.1 * minerals).ceil
    self.save
  end

  def increment_h_xp(food)
    self.harvesting_xp += (0.1 * food).ceil
    self.save
  end

  def increment_energy_level(food)
    initial_energy = self.energy
    if (self.energy + food) <= 16
      self.energy += food
    else
      self.energy = 16
    end
    self.save
    ending_energy = self.energy - initial_energy
  end

  def decrement_energy_level(x, y)
    self.energy -= Math.sqrt(x^2 + y^2)
    self.save
  end


  def alive?
    unless self.energy > 0
      self.destroy
    end
    self.status
  end

  def increment_distance_travelled(x, y)
    self.distance_travelled += Math.sqrt(x^2 + y^2)
    self.save
  end

  def increment_minerals_mined(minerals)
    self.minerals_mined += minerals
    self.save
  end

  def increment_food_harvested(food)
    self.food_harvested += food
    self.save
  end

end

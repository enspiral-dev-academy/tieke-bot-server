class Bot < ActiveRecord::Base
  belongs_to :stockpile

  #when is a stockpile being initiated?
  after_create do
    self.stockpile.mineral_count -= 8
  end

  def harvest(x, y)
      decrement_energy_level(x, y)
    if x.between?(1,10) && y.between?(1,10) && self.alive?
      #food_amount = call landscape server with coords & bot harvest xp
      increment_food_harvested(food_amount)
      add_to_stockpile(food_count, food_amount)
      increment_h_xp(food_amount)
      increment_distance_travelled(x, y)
    end
  end

  def mine(x, y)
      decrement_energy_level(x, y)
    if x.between?(1,10) && y.between?(1,10) && self.alive?
      #mineral_amount = call landscape server with coords & bot mining xp
      increment_minerals_mined(mineral_amount)
      add_to_stockpile(mineral_count, mineral_amount)
      increment_m_xp(mineral_amount)
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

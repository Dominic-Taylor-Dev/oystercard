# frozen_string_literal: true

# this class provides blueprint for oystercard instances
class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 0

  attr_reader :balance
  
  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    raise "Max balance is #{MAX_BALANCE}" if amount + @balance > MAX_BALANCE

    @balance += amount
  end

  def deduct(amount)
    raise "Min balance is #{MIN_BALANCE}" if @balance - amount < MIN_BALANCE

    @balance -= amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    raise 'You need at least £1 to touch in' if @balance < 1
    
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end
end

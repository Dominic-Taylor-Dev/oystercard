# frozen_string_literal: true

require_relative './journey_history'

# this class provides blueprint for oystercard instances
class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 0
  MIN_CHARGE = 1

  attr_reader :balance, :history, :journey

  def initialize
    @balance = 0
    @journey = {
      entry_station: nil,
      exit_station: nil
    }
    @history = []
  end

  def top_up(amount)
    raise "Max balance is #{MAX_BALANCE}" if amount + @balance > MAX_BALANCE

    @balance += amount
  end

  def in_journey?
    !!@journey[:entry_station]
  end

  def touch_in(current_station)
    raise "You need at least £#{MIN_CHARGE} to touch in" if @balance < MIN_CHARGE

    @journey[:entry_station] = current_station
  end

  def touch_out(exit_station)
    deduct(MIN_CHARGE)
    @journey[:exit_station] = exit_station
    @history.push(journey.clone)
    @journey[:entry_station] = nil
    @journey[:exit_station] = nil
  end

  private
  def deduct(amount)
    raise "Min balance is #{MIN_BALANCE}" if @balance - amount < MIN_BALANCE

    @balance -= amount
  end
end

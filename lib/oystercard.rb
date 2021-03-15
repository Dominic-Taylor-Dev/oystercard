
class Oystercard
  MAX_BALANCE = 90

  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(amount)
    raise 'Max balance is #{MAX_BALANCE}' if amount + @balance > MAX_BALANCE
    @balance += amount
  end
end

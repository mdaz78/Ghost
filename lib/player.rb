# frozen_string_literal: true

# Create class Player
class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess
    print "Enter your guess #{@name} : "
    gets.chomp
  end

  def alert_invalid_guess
    'Invalid Guess'
  end
end

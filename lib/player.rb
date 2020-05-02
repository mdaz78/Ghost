# frozen_string_literal: true

# Create class Player
class Player
  attr_accessor :name, :can_play

  def initialize(name)
    @name = name
    @can_play = true # indicates whether a player can play or not
  end

  def guess
    print "Enter your guess #{@name} : "
    gets.chomp
  end

  def alert_invalid_guess
    'Invalid Guess'
  end
end

# frozen_string_literal: true

require 'set'
require_relative './player'

# Create a Game Class
class Game
  def initialize(*player_names)
    @players = player_names.map { |player_name| Player.new(player_name) }
    @fragment = ''
    @dictionary = nil
  end

  def dictionary
    return @dictionary unless @dictionary.nil?

    @dictionary = Set.new(fetch_words_array)
  end

  def fetch_words_array
    words_array = []
    file = File.open('./dictionary.txt')
    file.each_line do |line|
      words_array << line.chomp
    end
    words_array
  end

  def current_player
    @players.first
  end

  def previous_player
    @players.last
  end

  def next_player!
    @players[0], @players[1] = @players[1], @players[0]
  end

  def take_turn(player)
    puts "Word : #{@fragment}" if @fragment.length > 0
    guess = player.guess
    temp_fragment = @fragment + guess
    until valid_play?(temp_fragment)
      p player.alert_invalid_guess
      guess = player.guess
      temp_fragment = @fragment + guess
    end
    @fragment = temp_fragment
  end

  def valid_play?(string)
    @dictionary ||= dictionary
    @dictionary.each do |word|
      return true if word.include?(string)
    end
    false
  end

  def play_round
    loop do
      take_turn(current_player)
      next_player!
    end
  end
end

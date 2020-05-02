# frozen_string_literal: true

require 'set'
require_relative './player'

# Create a Game Class
class Game
  def initialize(*player_names)
    @players = player_names.map { |player_name| Player.new(player_name) }
    @fragment = ''
    @dictionary = nil
    @losses = make_losses_hash
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
    take_turn(current_player)
    next_player!
  end

  def make_losses_hash
    @losses = {}
    @players.each do |player|
      @losses[player] = ''
    end
    @losses
  end

  def record_loss
    score_string = 'GHOST'
    index_of_loss = losses[current_player].length
    losses[current_player] += score_string[index_of_loss]
    @fragment = ''
  end

  def lose?
    @losses[current_player] == 'GHOST'
  end

  def remove_player_who_has_lost
    @players.delete(current_player) if lose?
  end

  def win?
    @players.length == 1
  end

  def run
    play_round until win?
  end
end

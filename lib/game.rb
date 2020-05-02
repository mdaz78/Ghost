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
    puts "Word : #{@fragment}" unless @fragment.empty?
    guess = player.guess
    temp_fragment = @fragment + guess
    until valid_play?(temp_fragment)
      p player.alert_invalid_guess
      guess = player.guess
      temp_fragment = @fragment + guess
    end
    @fragment = temp_fragment
    record_loss if @dictionary.include?(@fragment)
  end

  def valid_play?(string)
    @dictionary ||= dictionary
    @dictionary.each do |word|
      return true if word.include?(string)
    end
    false
  end

  def play_round
    print_score_card
    take_turn(current_player)
    next_player!
  end

  def print_score_card
    puts '========== Score Card =========='
    @losses.each do |player_name, score|
      puts "#{player_name} : #{score}"
    end
    puts '================================'
  end

  def make_losses_hash
    @losses = {}
    @players.each do |player|
      @losses[player.name] = ''
    end
    @losses
  end

  def record_loss
    score_string = 'GHOST'
    index_of_loss = @losses[current_player.name].length
    @losses[current_player.name] += score_string[index_of_loss]
    @fragment = ''
    remove_player_who_has_lost
  end

  def lose?
    @losses[current_player.name] == 'GHOST'
  end

  def remove_player_who_has_lost
    current_player.can_play = false if lose?
  end

  def win?
    @players.count { |player| player.can_play == true } == 1
  end

  def run
    play_round until win?
    puts "#{current_player.name} won the game" if win?
  end
end

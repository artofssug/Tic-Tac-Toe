# frozen_string_literal: true

require_relative './person'
require_relative './gametext'

# Define board and methods for gameplay
class Game
  include GameText

  attr_reader :turn
  attr_accessor :round, :board

  def initialize
    @board = Array.new(3) { Array.new(3, ' ') }
    @round = 1
    @player1 = nil
    @player2 = nil
  end

  def welcome
    introduction_txt
  end

  def create_players
    name1 = name_input('one')
    name2 = name_input('two')
    players_symbol(name1, name2)
  end

  def name_input(player)
    loop do
      puts "\nPlayer #{player}, enter a valid name:"
      name = gets.chomp.strip
      return name unless [nil, '', ' '].include?(name)

      puts "\n'#{name}' is not a valid name. Try again.\n"
    end
  end

  def players_symbol(player1_name, player2_name)
    loop do
      puts "\n#{player1_name}, which do you choose to be your symbol? X or O?"
      player1_symbol = gets.chomp.strip.upcase
      next puts "\n'#{player1_symbol}' is a invalid symbol. Try again." unless %w[X O].include?(player1_symbol)

      player2_symbol = 'O' if player1_symbol == 'X'
      player2_symbol = 'X' if player1_symbol == 'O'
      players = [[player1_name, player1_symbol], [player2_name, player2_symbol]]
      break instance_players(players)
    end
  end

  def instance_players(players)
    player1_name = players[0][0]
    player1_symbol = players[0][1]
    player2_name = players[1][0]
    player2_symbol = players[1][1]
    @player1 = Player.new(player1_name, player1_symbol)
    @player2 = Player.new(player2_name, player2_symbol)
    puts "\nIt's #{@player1.name}(#{@player1.symbol}) VS #{@player2.name}(#{@player2.symbol})!"
  end

  def who_goes_first
    puts "\nOk. Who goes first? #{@player1.name} or #{@player2.name}?"
    player_name = gets.chomp.downcase.strip
    players = [@player1.name.downcase, @player2.name.downcase]
    return player_name if players.any?(player_name)

    puts "\n'#{player_name}' is not a valid player. Try again."
    who_goes_first
  end

  def setup(name)
    if name == @player2.name.downcase
      first = @player2
      second = @player1
    else
      first = @player1
      second = @player2
    end

    let_the_battle_begins
    game_turn(first, second)
  end

  def game_turn(first, second, round = @round, current_player = first)
    puts "\nTurn #{round}!"
    location = location(current_player)
    update_board(location, current_player.symbol)
    return if game_end?(current_player)

    return game_turn(first, second, round + 1, second) if current_player == first

    return game_turn(first, second, round + 1, first) if current_player == second
  end

  def location(player)
    loop do
      puts "\n#{player.name}, enter the row you want to mark:"
      row = gets.chomp.strip
      puts 'Now enter the column you want to mark:'
      column = gets.chomp.strip
      location = [row.to_i, column.to_i]

      return location if valid_cell?(location)

      puts "\nWell, seems #{location} is not a valid cell. Try gain."
    end
  end

  def valid_cell?(cell)
    cell.all? { |i| i.is_a?(Integer) && i.positive? && i <= 3 } && unmarked?(cell)
  end

  def update_board(location, symbol)
    @board[location[0] - 1][location[1] - 1] = symbol
    puts "\nThis is the current board:"
    puts "\n"
    show_board
  end

  def game_end?(player)
    if winner?
      puts "\n#{player.name} won! YEYYYYY"
      true
    elsif tie
      puts "\nIt\'s a tie!"
      true
    else
      false
    end
  end

  def unmarked?(location)
    @board[location[0] - 1][location[1] - 1] == ' '
  end

  def tie
    return false if @board.any? { |cell| cell.include?(' ') }

    true
  end

  def winner?
    check_rows || check_columns || check_diagonal_left || check_diagonal_right
  end

  def show_board
    row1 = @board[0]
    row2 = @board[1]
    row3 = @board[2]
    puts "    #{row1[0]} | #{row1[1]} | #{row1[2]}
    --+---+--
    #{row2[0]} | #{row2[1]} | #{row2[2]}
    --+---+--
    #{row3[0]} | #{row3[1]} | #{row3[2]}"
  end

  def check_columns
    i = 0
    while i < @board.length
      column = @board.map { |row| row[i] }.uniq
      return true if column != [' '] && column.length == 1

      i += 1
    end
  end

  def check_rows
    i = 0
    while i < @board.length
      row = @board[i].uniq
      return true if row != [' '] && row.length == 1

      i += 1
    end
  end

  def check_diagonal_left
    i = 0
    while i < @board.length
      j = -1
      diagonal_left = @board.map { |row| row[j += 1] }.uniq
      return true if diagonal_left != [' '] && diagonal_left.length == 1

      i += 1
    end
  end

  def check_diagonal_right
    i = 0
    while i < @board.length
      j = 3
      diagonal_right = @board.map { |row| row[j -= 1] }.uniq
      return true if diagonal_right != [' '] && diagonal_right.length == 1

      i += 1
    end
  end
end

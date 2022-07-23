# frozen_string_literal: true

# Define board and methods for gameplay
class Game
  attr_reader :turn
  attr_accessor :round, :board

  def initialize
    @board = Array.new(3) { Array.new(3, ' ') }
    @round = 1
  end

  def show_friendly_board
    "\n    1 1 | 1 2 | 1 3
    ----+-----+----
    2 1 | 2 2 | 2 3
    ----+-----+----
    3 1 | 3 2 | 3 3"
  end

  def update_board(location, symbol)
    @board[location[0]][location[1]] = symbol
    puts "\nThis is the current board:"
    puts "\n"
    show_board
  end

  def already_marked?(location)
    return true unless @board[location[0]][location[1]] == ' '

    false
  end

  def invalid_cell?(location)
    return true unless @board[location[0]].instance_of?(Array) || @board[location[0]][location[1]].instance_of?(String)

    false
  end

  def get_location(player)
    loop do
      location = []
      puts "\n#{player.name}, enter the row that you want to mark:"
      row = gets.chomp.strip
      puts 'Now enter the column that you want to mark:'
      column = gets.chomp.strip
      location << row.to_i - 1 << column.to_i - 1
      case update_board?(location)
      when true
        update_board(location, player.symbol)
        break
      else
        puts "Well, seems that [#{row}, #{column}] is not a valid cell. Try gain!"
        next
      end
    end
  end

  def update_board?(location)
    if location[0].negative? || location[1].negative? || location[0] > 3 || location[1] > 3
      false
    elsif invalid_cell?(location)
      false
    elsif already_marked?(location)
      false
    else
      true
    end
  end

  private

  def show_board
    puts "    #{@board[0][0]} | #{@board[0][1]} | #{@board[0][2]}
    --+---+--
    #{@board[1][0]} | #{@board[1][1]} | #{@board[1][2]}
    --+---+--
    #{@board[2][0]} | #{@board[2][1]} | #{@board[2][2]}"
  end

  def check_columns
    i = 0
    while i < @board.length
      columns = @board.map { |row| row[i] }.uniq
      return true if columns != [' '] && columns.length == 1

      i += 1
    end
  end

  def check_rows
    i = 0
    while i < @board.length
      rows = @board[i].uniq
      return true if rows != [' '] && rows.length == 1

      i += 1
    end
  end

  def check_diagonal_left
    i = 0
    while i < @board.length
      j = -1
      columns = @board.map { |row| row[j += 1] }.uniq
      return true if columns != [' '] && columns.length == 1

      i += 1
    end
  end

  def check_diagonal_right
    i = 0
    while i < @board.length
      j = 3
      columns = @board.map { |row| row[j -= 1] }.uniq
      return true if columns != [' '] && columns.length == 1

      i += 1
    end
  end

  public

  def winner?
    true if check_rows || check_columns || check_diagonal_left || check_diagonal_right
  end
end

# define the players
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

# Show rules
puts "Welcome to my implementation of Tic-Tac-Toe!
\nFirst, I need to explain just one thing to you:
\n>Press ENTER to continue.<"
gets.chomp

puts "This is your board:
\n1 1 | 1 2 | 1 3
----+-----+----
2 1 | 2 2 | 2 3
----+-----+----
3 1 | 3 2 | 3 3
\nIn each cell, the first number is the row index,
and the second is the column index.
Thus, (2 3) is equivalent to (second row[2], third column[3]).
\n>Press ENTER to continue.<"
gets.chomp

puts "This it it. Pretty simple, right?
So, shall we begin?
\n>Press ENTER to continue.<"
gets.chomp

# Get both players name and symbol
puts 'Player one, enter your name:'
player1_name = gets.chomp.strip
puts 'What do you choose to be your symbol? X or O?'
player1_symbol = gets.chomp.strip.upcase
until %w[X O].include?(player1_symbol)
  puts "\n\"#{player1_symbol}\" is a invalid symbol. Please, enter X or O."
  player1_symbol = gets.chomp.strip.upcase
end

case player1_symbol
when 'X' then player2_symbol = 'O'
when 'O' then player2_symbol = 'X'
else return
end

puts "\nPlayer two, enter your name:"
player2_name = gets.chomp.strip

# Start instance variables
game = Game.new
player1 = Player.new(player1_name, player1_symbol)
player2 = Player.new(player2_name, player2_symbol)

puts "\nOk! #{player1.name}(#{player1.symbol}) VS #{player2.name}(#{player2.symbol})!
\nLets do this!
\n>Press ENTER to continue.<"
gets.chomp

puts "Who goes first? #{player1_name} or #{player2_name}?"
goes_first = gets.chomp.downcase.strip

until goes_first == player1.name.downcase || goes_first == player2.name.downcase
  puts "OOPS! Seems #{goes_first.capitalize} is not a player. Try again!"
  goes_first = gets.chomp.downcase.strip
end

case goes_first
when player1.name.downcase
  goes_first = player1
  goes_second = player2
else
  goes_first = player2
  goes_second = player1
end

puts "\nNow.. let the battle begins."
puts "\n>Press ENTER to continue.<"
gets.chomp
puts 'Remember: these are the cells:'
puts game.show_friendly_board

until game.winner?
  puts "\nTurn #{game.round}!"
  game.get_location(goes_first)
  if game.winner?
    puts "\n#{goes_first.name} won! YEYYYYY"
    break
  end
  game.get_location(goes_second)
  if game.winner?
    puts "\n#{goes_second.name} won! YEYYYYY"
    break
  end
  puts "\nAnother turn!"
  game.round += 1
end

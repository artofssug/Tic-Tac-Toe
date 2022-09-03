# frozen_string_literal: true

# Texts for Game class
module GameText
  def introduction_txt
    introduction_welcome
    friendly_board
    introduction_rules
    introduction_end
  end

  def introduction_welcome
    puts "Welcome to my implementation of Tic-Tac-Toe!
    \nFirst, I need to explain just one thing to you:
    \n>Press ENTER to continue.<"
    gets.chomp
    puts 'This is your board:'
  end

  def introduction_rules
    puts "\nIn each cell, the first number is the row index,\n" \
    "and the second is the column index.\n" \
    "Thus, (2 3) is equivalent to (second row[2], third column[3]).\n" \
    "\n>Press ENTER to continue.<"
    gets.chomp
  end

  def introduction_end
    puts "This it it. Pretty simple, right?\n" \
    "So, shall we begin?\n" \
    "\n>Press ENTER to continue.<"
    gets.chomp
  end

  def friendly_board
    puts "\n    1 1 | 1 2 | 1 3
    ----+-----+----
    2 1 | 2 2 | 2 3
    ----+-----+----
    3 1 | 3 2 | 3 3"
  end

  def let_the_battle_begins
    puts "\nNow.. let the battle begins."
    puts "\n>Press ENTER to continue.<"
    gets.chomp
    puts 'Remember: these are the cells:'
    friendly_board
  end
end

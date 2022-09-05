# frozen_string_literal: true

require_relative './game'

game = Game.new
game.welcome
game.create_players
first_player_name = game.who_goes_first
game.setup(first_player_name)

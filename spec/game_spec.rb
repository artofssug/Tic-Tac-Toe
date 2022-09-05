# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  describe '#create_players' do
    subject(:game_create) { described_class.new }
    let(:player1) { double('Player one') }
    let(:player2) { double('Two') }

    context 'when getting user input for the players names' do
      before do
        valid_name = 'Gustavo'
        second_valid_name = 'Tabata'
        allow(game_create).to receive(:gets)
        allow(game_create).to receive(:name_input).with('one').and_return(valid_name)
        allow(game_create).to receive(:name_input).with('two').and_return(second_valid_name)
      end

      it 'sends players_symbol' do
        expect(game_create).to receive(:players_symbol).with('Gustavo', 'Tabata').once
        game_create.create_players
      end
    end
  end

  describe '#name_input' do
    subject(:game_input) { described_class.new }

    context 'when user enters a valid name' do
      before do
        allow(game_input).to receive(:gets).and_return('Gustavo')
        allow(game_input).to receive(:puts)
      end

      it 'receive gets method only once' do
        expect(game_input).to receive(:gets).once
        game_input.name_input('one')
      end

      it 'does not display a error message' do
        name = 'Gustavo'
        error_message = "\n'#{name}' is not a valid name. Try again.\n"
        expect(game_input).not_to receive(:puts).with(error_message)
        game_input.name_input('one')
      end

      it 'returns the name' do
        name = 'Gustavo'
        result = game_input.name_input('one')
        expect(result).to eq(name)
      end
    end

    context 'when user enters a invalid name, then a valid name' do
      before do
        allow(game_input).to receive(:gets).and_return('', 'Gustavo')
        allow(game_input).to receive(:puts)
      end

      it 'receive gets method twice' do
        expect(game_input).to receive(:gets).twice
        game_input.name_input('one')
      end

      it 'display a error message once' do
        error_message = "\n'' is not a valid name. Try again.\n"
        expect(game_input).to receive(:puts).with(error_message).once
        game_input.name_input('one')
      end

      it 'returns the valid name' do
        name = 'Gustavo'
        result = game_input.name_input('one')
        expect(result).to eq(name)
      end
    end

    context 'when user enters four invalid names, then a valid name' do
      before do
        allow(game_input).to receive(:gets).and_return('', ' ', '', ' ', 'Gustavo')
        allow(game_input).to receive(:puts)
      end

      it 'receive gets method five times' do
        expect(game_input).to receive(:gets).exactly(5).times
        game_input.name_input('one')
      end

      it 'display error message four times' do
        error_message = "\n'' is not a valid name. Try again.\n"
        expect(game_input).to receive(:puts).with(error_message).exactly(4).times
        game_input.name_input('one')
      end

      it 'returns the valid name' do
        name = 'Gustavo'
        result = game_input.name_input('one')
        expect(result).to eq(name)
      end
    end
  end

  describe '#players_symbol' do
    subject(:game_symbol) { described_class.new }

    context 'when user enters a valid symbol(X)' do
      before do
        allow(game_symbol).to receive(:puts)
        allow(game_symbol).to receive(:gets).and_return('X')
      end

      it 'sends instance_players' do
        player1_name = 'Gustavo'
        player2_name = 'Tabata'
        players = [%w[Gustavo X], %w[Tabata O]]
        expect(game_symbol).to receive(:instance_players).with(players)
        game_symbol.players_symbol(player1_name, player2_name)
      end

      it 'receive gets method once' do
        player1_name = 'Gustavo'
        player2_name = 'Tabata'
        expect(game_symbol).to receive(:gets).once
        game_symbol.players_symbol(player1_name, player2_name)
      end

      it "sets 'O' as the symbol for the another player" do
        player1_name = 'Gustavo'
        player2_name = 'Tabata'
        players = [%w[Gustavo X], %w[Tabata O]]
        expect(game_symbol).to receive(:instance_players).with(players)
        game_symbol.players_symbol(player1_name, player2_name)
      end
    end

    context 'when user enters a valid symbol(O)' do
      before do
        allow(game_symbol).to receive(:puts)
        allow(game_symbol).to receive(:gets).and_return('O')
      end

      it 'sends instance_players once' do
        player1_name = 'Gustavo'
        player2_name = 'Tabata'
        players = [%w[Gustavo O], %w[Tabata X]]
        expect(game_symbol).to receive(:instance_players).with(players).once
        game_symbol.players_symbol(player1_name, player2_name)
      end

      it 'receive gets method once' do
        player1_name = 'Gustavo'
        player2_name = 'Tabata'
        expect(game_symbol).to receive(:gets).once
        game_symbol.players_symbol(player1_name, player2_name)
      end

      it "sets 'X' as the symbol for the another player" do
        player1_name = 'Gustavo'
        player2_name = 'Tabata'
        players = [%w[Gustavo O], %w[Tabata X]]
        expect(game_symbol).to receive(:instance_players).with(players)
        game_symbol.players_symbol(player1_name, player2_name)
      end
    end
  end

  describe '#instance_players' do
    subject(:game_instance) { described_class.new }
    let(:player) { class_double(Player) }
    let(:player1) { instance_double(Player, name: 'Gustavo', symbol: 'X') }
    let(:player2) { instance_double(Player, name: 'Tabata', symbol: 'O') }

    before do
      allow(game_instance).to receive(:puts)
    end

    it 'create instance players' do
      player1_name = 'Gustavo'
      player1_sym = 'X'
      player2_name = 'Tabata'
      player2_sym = 'O'
      players_info = [[player1_name, player1_sym], [player2_name, player2_sym]]
      expect(Player).to receive(:new).with(player1_name, player1_sym).and_return(player1)
      expect(Player).to receive(:new).with(player2_name, player2_sym).and_return(player2)
      game_instance.instance_players(players_info)
    end
  end

  describe '#who_goes_first' do
    subject(:game_goes_first) { described_class.new }
    let(:player1) { instance_double(Player, name: 'Gustavo', symbol: 'X') }
    let(:player2) { instance_double(Player, name: 'Tabata', symbol: 'O') }

    context 'when user enters a valid player name' do
      before do
        game_goes_first.instance_variable_set(:@player1, player1)
        game_goes_first.instance_variable_set(:@player2, player2)
        allow(game_goes_first).to receive(:gets).and_return('Gustavo')
        allow(game_goes_first).to receive(:puts)
      end

      it 'returns the name' do
        result = game_goes_first.who_goes_first
        expect(result).to eq(player1.name.downcase)
      end
    end

    context 'when user enters a invalid player name, than a valid name' do
      before do
        game_goes_first.instance_variable_set(:@player1, player1)
        game_goes_first.instance_variable_set(:@player2, player2)
        allow(game_goes_first).to receive(:gets).and_return('Pedro', 'Gustavo')
        allow(game_goes_first).to receive(:puts)
      end

      it 'receives gets method twice' do
        expect(game_goes_first).to receive(:gets).twice
        game_goes_first.who_goes_first
      end

      it 'receive a error message once' do
        error_message = "\n'pedro' is not a valid player. Try again."
        expect(game_goes_first).to receive(:puts).with(error_message).once
        game_goes_first.who_goes_first
      end

      it 'returns the name' do
        result = game_goes_first.who_goes_first
        expect(result).to eq(player1.name.downcase)
      end
    end
  end

  describe '#setup' do
    subject(:game_setup) { described_class.new }
    let(:player1) { instance_double(Player, name: 'Gustavo', symbol: 'X') }
    let(:player2) { instance_double(Player, name: 'Tabata', symbol: 'O') }

    context 'when called with player1 name' do
      before do
        game_setup.instance_variable_set(:@player1, player1)
        game_setup.instance_variable_set(:@player2, player2)
        allow(game_setup).to receive(:puts)
      end

      it 'calls turn, where the first player to play is player1 and, the second, player2' do
        expect(game_setup).to receive(:turn).with(player1, player2)
        game_setup.setup('gustavo')
      end
    end

    context 'when called with player2 name' do
      before do
        game_setup.instance_variable_set(:@player1, player1)
        game_setup.instance_variable_set(:@player2, player2)
        allow(game_setup).to receive(:puts)
      end

      it 'calls turn, where the first player to play is player2 and, the second, player1' do
        expect(game_setup).to receive(:turn).with(player2, player1)
        game_setup.setup('tabata')
      end
    end
  end

  describe '#turn' do
    subject(:game_turn) { described_class.new }
    let(:player1) { instance_double(Player, name: 'Gustavo', symbol: 'X') }
    let(:player2) { instance_double(Player, name: 'Tabata', symbol: 'O') }

    context "when player1 goes first and it's his turn" do
      before do
        game_turn.instance_variable_set(:@player1, player1)
        game_turn.instance_variable_set(:@player2, player2)
        allow(game_turn).to receive(:gets).and_return('1', '2')
        allow(game_turn).to receive(:puts)
      end

      context 'and the current player marks a cell that leads to a win' do
        before do
          current_board = Array.new(3) do |row_index|
            Array.new(3) do |column_index|
              row_index.zero? && (column_index.zero? || column_index == 2) ? 'X' : ' '
            end
          end
          game_turn.instance_variable_set(:@board, current_board)
        end

        it 'finish the game' do
          result = game_turn.turn(player1, player2)
          expect(result).to be 'finished'
        end

        it 'receives input_cell only once' do
          expect(game_turn).to receive(:update_board).with([1, 2], 'X').and_call_original.once
          game_turn.turn(player1, player2)
        end
      end

      context 'and he marks a cell that does not leads to a win, but the other player do' do
        before do
          current_board = Array.new(3) do |row_index|
            Array.new(3) do |column_index|
              if row_index.zero? && (column_index.zero? || column_index == 2)
                'X'
              elsif row_index == 2 && (column_index.zero? || column_index == 2)
                'O'
              else
                ' '
              end
            end
          end
          game_turn.instance_variable_set(:@board, current_board)
          allow(game_turn).to receive(:gets).and_return('2', '1', '3', '2')
        end

        it 'finish the game' do
          result = game_turn.turn(player1, player2)
          expect(result).to be 'finished'
        end

        it 'receives input_cell twice' do
          expect(game_turn).to receive(:update_board).and_call_original.twice
          game_turn.turn(player1, player2)
        end
      end
    end
  end
end

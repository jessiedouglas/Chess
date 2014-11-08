require 'yaml'
require_relative 'board'

class InputError < StandardError
end

class Game
  PLAYERS = {:white => "White", :black => "Black"}

  attr_accessor :current_player
  attr_reader :board

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:black)
    @players = [@player1, @player2]
    @current_player = @player1
  end

  def play

    until self.board.won?
      system("clear")
      puts board
      puts "It is #{PLAYERS[current_player.color]}'s turn."
      puts "What is your move? (use standard chess notation)"
      puts "(or type 'save' to save your game, 'quit' to quit)"

      begin
        input = gets.chomp.split(",").map(&:strip)
        case input.length
        when 0
          raise InputError.new
        when 1
          case input[0].downcase
          when "save"
            #current_player = opponent_of(current_player)
            save_game
            puts "Game saved. Enter next move."
          when "quit"
            abort
          else
            raise InputError.new "That is not a valid option, try again."
          end
        else
          start_pos, end_pos = self.current_player.parse_input(input)
          piece = board[start_pos]

          if piece.nil?
            raise InputError.new "That square is empty. Pick a new move (start and end)."
          end

          if piece.color != self.current_player.color
            raise InputError.new "That piece is not your color. Pick a new move (start and end)."
          end

          board.move(start_pos, end_pos)
        end

      rescue InputError => e
        puts e.message
        retry
      end

      self.current_player = opponent_of(self.current_player)
    end

    winner = PLAYERS[self.board.winner]
    puts "Checkmate! #{winner} wins."
  end

  def save_game
    puts "Enter a filename:"
    filename = gets.chomp
    File.write("./saves/#{filename}.yaml", self.to_yaml)
  end

  private
  def opponent_of(player)
    player == @player1 ? @player2 : @player1
  end
end

class HumanPlayer

  LETTERS = ("a".."h").to_a

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def parse_input(move)
    unless move.length == 2
      raise InputError.new "Please use standard chess notation"
    end

    start_position = convert_position(move[0])
    end_position = convert_position(move[1])

    [start_position, end_position]
  end

  def convert_position(notation)
    x = LETTERS.find_index(notation[0].downcase)
    raise InputError.new "Please use standard chess notation" if x.nil?

    begin
      y = 8 - Integer(notation[1])
    rescue ArgumentError
      raise InputError.new "Please use standard chess notation"
    end

    [x, y]
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.length > 0
    filename = ARGV.shift
    saved_game = File.read(filename)
    game = YAML::load(saved_game)
  else
    game = Game.new
  end

  game.play
end

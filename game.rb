require_relative 'board'

class EmptyStartError < StandardError
end

class StartPositionError < StandardError
end

class NotationError < StandardError
end

class Game
  PLAYERS = {:white => "White", :black => "Black"}

  attr_reader :board

  def initialize(board)
    @board = board
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:black)
    @players = [@player1, @player2]
  end

  def play
    current_player = @player1

    until self.board.won?
      system("clear")
      puts board
      puts "It is #{PLAYERS[current_player.color]}'s turn."
      puts "What is your move? (use standard chess notation)"

      begin
        start_pos, end_pos = current_player.play_turn
        piece = board[start_pos]

        raise EmptyStartError.new if piece.nil?
        raise StartPositionError.new if piece.color != current_player.color

        board.move(start_pos, end_pos)

      rescue EmptyStartError
        puts "That square is empty. Pick a new move (start and end)."
        retry

      rescue StartPositionError
        puts "That piece is not your color. Pick a new move (start and end)."
        retry

      rescue EndPositionError
        puts "You can't move there. Pick a new move (start and end)."
        retry

      rescue NotationError
        puts "Please use standard chess notation"
        retry
      end

      current_player = opponent_of(current_player)
    end

    winner = PLAYERS[self.board.winner]
    puts "Checkmate! #{winner} wins."
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

  def play_turn

    move = gets.chomp.split(",").map(&:strip)
    raise NotationError unless move.length == 2

    start_position = convert_position(move[0])
    end_position = convert_position(move[1])

    [start_position, end_position]
  end

  def convert_position(notation)
    x = LETTERS.find_index(notation[0].downcase)
    raise NotationError if x.nil?

    begin
      y = 8 - Integer(notation[1])
    rescue ArgumentError
      raise NotationError
    end

    [x, y]
  end
end


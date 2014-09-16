class Piece
  attr_accessor :position, :board, :color

  #change later
  def inspect
    self.class.to_s[0]
  end

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end

  def moves
    possible_moves = self.possible_moves
    possible_moves = check_on_board(possible_moves)
    possible_moves = check_color(possible_moves)
  end

  private
  def check_on_board(possible_moves)
    result = possible_moves.select do |move|
      x, y = move
      x.between?(0, 7) && y.between?(0, 7)
    end

    result
  end

  def check_color(possible_moves)
    result = possible_moves.select do |move|
      board.empty?(move) || board[move].color != self.color
    end

    result
  end
end

class SlidingPiece < Piece

  def initialize(*args)
    super(*args)
  end

  def possible_moves
    directions = self.class::DIRECTION_DELTAS
    moves = []

    directions.each do |direction|
      x, y = self.position
      dx, dy = direction
      collision = false

      until collision
        x += dx
        y += dy
        moves << [x, y]
        collision = true unless self.board.empty?([x,y])
      end
    end

    moves
  end

end

class SteppingPiece < Piece
  def initialize(*args)
    super(*args)
  end

  def possible_moves
    x, y = self.position

    moves = self.class::DELTAS.map do |delta|
      dx, dy = delta
      [x + dx, y + dy]
    end

    moves
  end

end

class Pawn < Piece
  def initialize(position, board, color)
    super(position, board, color)
    @starting_position = position
  end

  def possible_moves
    x, y = self.position
    possibilities = [[x, white_or_black(y, 1)]]

    if self.position == @starting_position
      possibilities << [x, white_or_black(y, 2)]
    end

    diags = [
      [x - 1, white_or_black(y, 1)],
      [x + 1, white_or_black(y, 1)]
    ]

    possibilities += diags.select do |diag|
      !self.board.empty?(diag)
    end

    possibilities
  end

  def white_or_black(y, dy)
    if self.color == :white
      y + dy
    else
      y - dy
    end
  end

end

class Bishop < SlidingPiece
  DIRECTION_DELTAS = [[1,1], [1,-1], [-1,1], [-1,-1]]

  def initialize(*args)
    super(*args)
  end
end

class Rook < SlidingPiece
  DIRECTION_DELTAS = [[1,0], [-1,0], [0,1], [0,-1]]

  def initialize(*args)
    super(*args)
  end
end

class Queen < SlidingPiece
  DIRECTION_DELTAS = Rook::DIRECTION_DELTAS + Bishop::DIRECTION_DELTAS

  def initialize(*args)
    super(*args)
  end
end

class King < SteppingPiece
  DELTAS = [
    [-1, -1], [0, -1], [1, -1],
    [-1,  0],          [1,  0],
    [-1,  1], [0,  1], [1,  1]
  ]

  def initialize(*args)
    super(*args)
  end

end

class Knight < SteppingPiece
  DELTAS = [
             [-1,  2], [ 1,  2],
    [-2,  1],                   [ 2,  1],
    [-2, -1],                   [ 2, -1],
             [-1, -2], [ 1, -2]
  ]

  def initialize(*args)
    super(*args)
  end

end
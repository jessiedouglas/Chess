require_relative 'chess.rb'

class StartPositionError < StandardError
end

class EndPositionError < StandardError
end

class InCheckError < StandardError
end

class Board

  def [](position)
    col, row = position
    @grid[row][col]
  end

  def []=(position, value)
    col, row = position
    @grid[row][col] = value
  end

  def empty?(position)
    x, y = position
    x.between?(0,7) && y.between?(0,7) && self[position].nil?
  end

  def board_dup # build that
    duped_board = Board.new
    grid_dup = []

    @grid.each do |row|
      row_dup = row.map do |piece|
        if piece.nil?
          piece
        else
          pos_dup = piece.position.dup
          piece_dup = piece.class.new(pos_dup, duped_board, piece.color)
        end
      end

      grid_dup << row_dup
    end

    duped_board.populate_board(grid_dup)

    duped_board
  end

  def in_check?(color)
    king_position = find_king(color)

    enemy_pieces = @grid.flatten.select do |piece|
      next if piece.nil?
      piece.color != color
    end

    enemy_pieces.each do |piece|
      moves = piece.moves

      return true if moves.any? {|position| position == king_position}
    end

    false
  end

  def find_king(color)
    @grid.flatten.each do |piece|
      return piece.position if piece.class == King && piece.color == color
    end

    nil
  end

  def checkmate?(color)
    our_pieces = @grid.flatten.select do |piece|
      next if piece.nil?
      piece.color == color
    end

    self.in_check?(color) && our_pieces.all? { |piece| piece.valid_moves.empty? }
  end

  def move(start, end_pos)
    piece = self[start]

    if piece.nil?
      raise StartPositionError.new
    end

    unless piece.valid_moves.include?(end_pos)
      raise InCheckError.new
    end

    piece.position = end_pos

    nil
  end

  def move!(start, end_pos)
    piece = self[start]
    if piece.nil?
      raise StartPositionError.new
    end

    unless piece.moves.include?(end_pos)
      raise EndPositionError.new
    end

    piece.position = end_pos

    nil
  end

  def populate_board(grid = nil)
    if grid.nil?
      @grid = Array.new(8) { Array.new(8) }
      populate_new_board
    else
      @grid = grid
    end

    nil
  end

  def populate_new_board
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    pieces.each_with_index do |piece, index|
      piece.new([index, 0], self, :black)
      Pawn.new([index, 1], self, :black)

      piece.new([index, 7], self, :white)
      Pawn.new([index, 6], self, :white)
    end

    nil
  end

  def display
    puts "   #{('a'..'h').to_a.join(" ")}"
    @grid.each_with_index do |row, i|
      print "#{8 - i}||"
      row.each do |tile|
        if tile.nil?
          print "__"
        else
          print "#{tile.unicode} "
        end
      end

      print "||#{8 - i}\n"
    end
    puts "   #{('a'..'h').to_a.join(" ")}"

    nil
  end
end
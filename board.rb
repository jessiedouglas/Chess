class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

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

end
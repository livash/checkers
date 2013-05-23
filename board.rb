#board for the Checkers game
require_relative 'piece.rb'

class Board
  attr_accessor :board
  def initialize
    @board = generate_board
    # p board.length
#     p board.first.length
  end
  
  def show_board
    puts "black pieces are: <o>,     white pieces are [0]"
    puts "  | a    b    c    d    e    f    g    h  "
    puts "  ________________________________________"
    puts
    @board.each_with_index do |row, idx|
      row_view = row.map do |piece|
        if piece.nil?
          '____'
        else
          case piece.color
          when :black
            " <#{piece.face}>"
          when :white
            " [#{piece.face}]"
          else
            "#{piece.face}"
          end
        end
        # (piece.face + '_' + piece.color.to_s)
      end
      puts "#{8 - idx}| #{row_view.join(' ')}"
      puts " |"
    end
  end
  
  def [](position)
    row, col = position
    board[row][col]
  end 
  
  def []=(position, value)
    row, col = position
    board[row][col] = value
  end 
  def perform_slide(from_pos, to_pos)
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    
    
    #make move on the board
    puts "valid_slide #{valid_slide?(board, from_pos, to_pos)}"
    if valid_slide?(board, from_pos, to_pos)
      board[[to_row, to_col]], board[[from_row, from_col]] = board[[from_row, from_col]], nil
      puts "Slide was performed"
    end
    puts "Slide was not made"
  end
  
  def perform_jump
    
  end

  private
  
  def generate_board
    new_board = []
    8.times do |row|
      new_board[row] = []
      8.times do |col|
        new_board[row][col] = nil  #BlankPiece.new
      end
    end
    puts "made the board"
    
    add_pieces(new_board)
  end
  
  def add_pieces(new_board)
    #row 8 and row 6, black pieces

    [0,2].each do |row_index|
      new_board[row_index].each_with_index do |piece, tile_index|
        
        new_board[row_index][tile_index] = Piece.new(:black) unless tile_index % 2 == 0
      end
    end
    # #row 7, black pieces
    new_board[1].each_with_index do |piece, tile_index|
      new_board[1][tile_index] = Piece.new(:black) if tile_index % 2 == 0
    end
    #row 1,3 white pieces
    [7,5].each do |row_index|
      new_board[row_index].each_with_index do |piece, tile_index|
        
        new_board[row_index][tile_index] = Piece.new(:white) unless tile_index % 2 == 0
      end
    end
    #row 2, white pieces
    new_board[6].each_with_index do |piece, tile_index|
      new_board[6][tile_index] = Piece.new(:white) if tile_index % 2 == 0
    end
    
    new_board
  end
  
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.show_board
  
end
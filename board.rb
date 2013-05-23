#board for the Checkers game
require_relative 'piece.rb'
require_relative 'conversion.rb'
require 'colorize'

class Board
  include Conversion
  attr_accessor :board
  def initialize
    @board = generate_board
  end
  
  def show_board
    puts "black pieces are: <o>,     white pieces are [0]"
    puts "  | a    b    c    d    e    f    g    h  ".colorize( :color => :light_blue, :background => :yellow )
    puts "  ________________________________________".colorize( :color => :light_blue, :background => :yellow )
    puts
    @board.each_with_index do |row, idx|
      row_view = row.map do |piece|
        if piece.nil?
          '____'
        else
          case piece.color
          when :black
            " <#{piece.face}>".colorize( :color => :white, :background => :red )
          when :white
            " [#{piece.face}]".colorize( :color => :black, :background => :white )
          else
            "#{piece.face}"
          end
        end
        # (piece.face + '_' + piece.color.to_s)
      end
      puts "#{8 - idx}| #{row_view.join(' ')}"
      puts " |"
    end
    puts "  | a    b    c    d    e    f    g    h  ".colorize( :color => :light_blue, :background => :yellow )
  end
  
  def [](position)
    row, col = position
    board[row][col]
  end 
  
  def []=(position, value)
    row, col = position
    board[row][col] = value
  end 
  
  def place_move_for(color, from_pos, to_pos) #return boolean
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    # calculate move length if ==1 then use perform_slide if == 2 then perform_jump 
    move_length = (from_col - to_col).abs
    if move_length <= 1
      return perform_slide(from_pos, to_pos)
    else # move_length > 1
      return perform_jump(from_pos, to_pos)
    end
  end
  
  def perform_slide(from_pos, to_pos) #returns boolean
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    piece = board[from_row][from_col]
    
    if valid_slide?(from_pos, to_pos)
      board[to_row][to_col], board[from_row][from_col] = board[from_row][from_col], nil
      puts "SLIDE was performed"
      return true
    end
    puts "SLIDE was NOT made. Try again..."
    false
  end
  
  def valid_slide?(from_pos, to_pos) # takes two strings
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    piece = board[from_row][from_col]
    
    #can not slide to occupied position
    return false if board[to_row][to_col].class == CheckerPiece
    
    #slide move is included in all_possible_moves for this piece
    piece.all_possible_moves_for_slide(from_pos).include?([to_row,to_col]) 
  end
  
  def perform_jump(from_pos, to_pos) #returns boolean
    #raise NotImplementedError
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    piece = board[from_row][from_col]
    
    if valid_jump?(from_pos, to_pos)
      board[to_row][to_col], board[from_row][from_col] = board[from_row][from_col], nil
      #remove pieces in the jump path
      puts "JUMP was performed"
      return true
    end
    puts "JUMP was NOT made. Try again..."
    false
  end
  
  def valid_jump?(from_pos, to_pos)
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    piece = board[from_row][from_col]
    jump_leng = (from_col - to_col).abs
    #can not jump to occupied position
    return false if board[to_row][to_col].class == CheckerPiece
    
    #jump move is included in all_possible_moves for this piece
    check_two = piece.all_possible_moves_for_jump(from_pos, jump_leng).include?([to_row,to_col])
    
    # #check_three  there is no pieces in jump positions
#     jump_path = piece.jump_path(from_pos, to_pos)
#     check_three = 
#     
#     # check_four there are CheckerPieces in between jump positions
#     
#     check_four = 
#     
#     
#     #return a boolean
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
        
        new_board[row_index][tile_index] = CheckerPiece.new(:black) unless tile_index % 2 == 0
      end
    end
    # #row 7, black pieces
    new_board[1].each_with_index do |piece, tile_index|
      new_board[1][tile_index] = CheckerPiece.new(:black) if tile_index % 2 == 0
    end
    #row 1,3 white pieces
    [7,5].each do |row_index|
      new_board[row_index].each_with_index do |piece, tile_index|
        
        new_board[row_index][tile_index] = CheckerPiece.new(:white) unless tile_index % 2 == 0
      end
    end
    #row 2, white pieces
    new_board[6].each_with_index do |piece, tile_index|
      new_board[6][tile_index] = CheckerPiece.new(:white) if tile_index % 2 == 0
    end
    
    new_board
  end
  
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.show_board
  # make valid slide
  b.perform_slide('b3','c4')
  b.show_board
  # make invalid slide
  b.perform_slide('d3','c4')
  b.show_board
  
end
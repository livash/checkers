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
    puts
    puts "black pieces are: <o>,     white pieces are [0]"
    puts "  | a    b    c    d    e    f    g    h  ".colorize( :color => :light_blue, :background => :yellow )
   # puts "  ________________________________________".colorize( :color => :light_blue, :background => :yellow )
    puts
    @board.each_with_index do |row, idx|
      row_view = row.map do |piece|
        if piece.nil?
          '____'.colorize( :color => :green, :background => :green )
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
    piece = board[from_row][from_col]
    
    unless is_players_piece(color, piece)
      puts "YOU CAN NOT MOVE OTHER PLAYER'S PIECE!!!"
      return false
    end
    # calculate move length if ==1 then use perform_slide if == 2 then perform_jump 
    move_length = (from_col - to_col).abs
    if move_length <= 1
      return perform_slide(from_pos, to_pos)
    else # move_length > 1
      return perform_jump(from_pos, to_pos)
    end
  end
  
  private
  
  def is_players_piece(color, piece)
    color == piece.color
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
    full_path, jump_touch_pos_path, jump_over_pos_path = piece.jump_path(from_pos, to_pos)
    
    if valid_jump?(from_pos, to_pos)
      board[to_row][to_col], board[from_row][from_col] = board[from_row][from_col], nil
      #remove pieces in the jump path
      remove_pieces(jump_over_pos_path)
      puts "JUMP was performed"
      return true
    end
    puts "JUMP was NOT made. Try again..."
    false
  end
  
  def valid_jump?(from_pos, to_pos)
    to_col, to_row = str_to_coord(to_pos)
  
    #can not jump to an occupied position
    puts "target tile is ocupied: #{tile_ocupied?(to_row, to_col)}"
    return false if tile_ocupied?(to_row, to_col)
    
    #jump move is included in all_possible_moves for this piece
    check_two = can_jump_to?(from_pos, to_pos)
    puts "check_ two: #{check_two}"
    
    # check_three  there is no pieces in jump positions
    check_three = jump_positions_clear?(from_pos, to_pos)
    puts "check_three = #{check_three}"
     
    # check_four there are CheckerPieces in between jump positions
    #check_four = jump_over_pos_path.none? { |(row,col)| board[row][col].nil? }
    check_four = jump_over_positions_not_empty?(from_pos, to_pos)
    
#     #return a boolean
  end
  
  def remove_pieces(array)
    array.each do |(row,col)|
        board[row][col] = nil
    end
  end
  
  def jump_over_positions_not_empty?(from_pos, to_pos)
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    piece = board[from_row][from_col]
    full_path, jump_touch_pos_path, jump_over_pos_path = piece.jump_path(from_pos, to_pos)
    
    jump_over_pos_path.all? { |(row,col)| board[row][col].class == CheckerPiece && board[row][col].color != piece.color}
  end
  
  def jump_positions_clear?(from_pos, to_pos)
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    piece = board[from_row][from_col]
    
    full_path, jump_touch_pos_path, jump_over_pos_path = piece.jump_path(from_pos, to_pos)
    #remove from_position from <jump_touch_pos_path>
    jump_touch_pos_path -= [[from_row, from_col]]
    
    jump_touch_pos_path.all? { |(row,col)| board[row][col].nil? }
  end
  
  def can_jump_to?(from_pos, to_pos)
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    piece = board[from_row][from_col]
    jump_leng = (from_col - to_col).abs
    
    piece.all_possible_moves_for_jump(from_pos, jump_leng).include?([to_row,to_col])
  end
  
  def tile_ocupied?(to_row, to_col)
    board[to_row][to_col].class == CheckerPiece
  end
  
  def generate_board
    new_board = []
    8.times do |row|
      new_board[row] = []
      8.times do |col|
        new_board[row][col] = nil  #BlankPiece.new
      end
    end
    #puts "made the board"
    
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
        new_board[row_index][tile_index] = CheckerPiece.new(:white) if tile_index % 2 == 0
      end
    end
    #row 2, white pieces
    new_board[6].each_with_index do |piece, tile_index|
      new_board[6][tile_index] = CheckerPiece.new(:white) unless tile_index % 2 == 0
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
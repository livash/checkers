# piece class for the checkers game
require_relative "conversion.rb"
require_relative "board.rb"

class CheckerPiece
  include Conversion
  
  MOVE_DIRECTIONS = [
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1]
  ]
  attr_accessor :color
  attr_reader :face
  
  def initialize(color)
    @color = color
    @face = "o"
  end
  
  def all_possible_moves_for_slide(position)
    col, row = str_to_coord(position)
    possible_pos_array = []
     MOVE_DIRECTIONS.each do |(drow, dcol)|
       new_row = row + drow
       new_col = col + dcol
       possible_pos_array << [new_row, new_col] if board_has?(new_row, new_col) 
     end
     
     possible_pos_array
  end
  
  def all_possible_moves_for_jump(position, jump_leng)
    col, row = str_to_coord(position)
    possible_pos_array = []
     MOVE_DIRECTIONS.each do |(drow, dcol)|
       new_row = row + drow * jump_leng
       new_col = col + dcol * jump_leng
       possible_pos_array << [new_row, new_col] if board_has?(new_row, new_col) 
     end
     
     possible_pos_array
  end
  
  def jump_path(from_pos, to_pos)
    path = []
    jump_touch_pos_path = []
    jump_over_pos_path = []
    from_col, from_row = str_to_coord(from_pos)
    to_col, to_row = str_to_coord(to_pos)
    drow = (to_row - from_row) / (to_row - from_row).abs
    dcol = (to_col - from_col) / (to_col - from_col).abs
    path_leng = 1 + (from_col - to_col).abs
    
    (0...path_leng).each do |pos_increment|
      new_row = from_row + drow * pos_increment
      new_col = from_col + dcol * pos_increment
      path << [new_row, new_col] if board_has?(new_row, new_col) 
      jump_touch_pos_path << [new_row, new_col] if pos_increment % 2 == 0
      jump_over_pos_path << [new_row, new_col] if pos_increment % 2 != 0
    end
    # puts "Full path #{path}"
#     puts "touched positions #{jump_touch_pos_path}"
#     puts "jumped over positions#{jump_over_pos_path}"
#     
    [path, jump_touch_pos_path, jump_over_pos_path]
  end
  
  def board_has?(row, col)
    (0..7).include?(row) && (0..7).include?(col)
  end
  
end

if __FILE__ == $PROGRAM_NAME
  
  #TEST perform slide
  b = Board.new
  b.show_board
  piece = b[[5, 1]]
  p "#{piece.face}"
  piece.perform_slide(b, 'b3', 'c4')
    b.show_board
  
  #piece = Piece.new(:white)
 
  
  
  #p "a8 = #{piece.str_to_coord('a8')}"
  
  #TEST Piece
  # piece = Piece.new(:white)
  # p piece.class
  # p piece.face
  # p piece.color
  # 
  # piece = Piece.new(:black)
  # p piece.class
  # p piece.face
  # p piece.color
  
end
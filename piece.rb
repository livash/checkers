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
    jump_leng_array = []
    (2..jump_leng).each do |jump|
      jump_leng_array << jump if jump % 2 == 0
    end
     MOVE_DIRECTIONS.each do |(drow, dcol)|
       new_row = row + drow * jump_leng
       new_col = col + dcol * jump_leng
       possible_pos_array << [new_row, new_col] if board_has?(new_row, new_col) 
     end
     
     possible_pos_array
  end
  
  def board_has?(row, col)
    (0..7).include?(row) && (0..7).include?(col)
  end
  
end

# class BlankPiece < Piece
#  
#   def initialize(color = nil)
#     super(color)
#     @face = "____"
#   end
#   
# end

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
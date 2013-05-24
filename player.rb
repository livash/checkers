class	Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def ask_move
    # OPTIMIZE: add error checking
    print "#{name}, #{color} checkers, enter your move [ex: f4, f5]:  "
    move = gets.chomp.gsub(" ", "") #.split(",")
    start_pos, target_pos = move.split(",")
    [start_pos, target_pos]
  end
end
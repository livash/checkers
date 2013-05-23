#game class for the CHeckers game
require_relative 'player.rb'
require_relative 'board.rb'
class Game
  attr_accessor :players, :game_board
  
  def initialize(player1, player2)
    @players = [player1, player2] # first is white, second is black
    @game_board = Board.new #(players)
  end
  
  def play
    player = players[0]
      until game_over?
        move_placed = false
        until move_placed
          game_board.show_board
          start_pos, target_pos = player.ask_move #move_array = [f4, f3]
          move_placed = game_board.place_move_for(player.color, start_pos, target_pos)
        end
        player = next_player(player)
      end
      #print out win lose message
    end
  end
  
end

if __FILE__ == $PROGRAM_NAME
  
  game = Game.new
  
end
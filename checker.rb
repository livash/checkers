#checkres game run file

require_relative "game.rb"

jon = Player.new("jon", :black)
olena = Player.new("olena", :white)
checkers = Game.new(jon, olena)
checkers.play #(jon, olena)

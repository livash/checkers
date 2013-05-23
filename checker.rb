#checkres game run file

require_relative "game.rb"

sean = Player.new("jon", :black)
olena = Player.new("olena", :white)
checkers = Game.new(sean, olena)
chekers.play #(sean, olena)
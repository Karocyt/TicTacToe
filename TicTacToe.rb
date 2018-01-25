require 'pry'

class Board
	attr_reader :c

	def initialize
		@c = [[' ',' ',' '],
					[' ',' ',' '],
					[' ',' ',' ']] 
	end

	def show
		puts 	"    1   2   3\n1 - #{@c[0].join(' | ')}\n    _________\n2 - #{@c[1].join(' | ')}\n    _________\n3 - #{@c[2].join(' | ')}\n\n"
	end

	def check
		win = @c[0][0] if 	@c[0][0] != ' ' && (@c[0][0] == @c[0][1] && @c[0][1] == @c[0][2]) || (@c[0][0] == @c[1][0] && @c[1][0] == @c[2][0]) || (@c[0][0] == @c[1][1] && @c[1][1] == @c[2][2])
		win = @c[0][1] if 	@c[0][1] != ' ' && (@c[0][1] == @c[1][1] && @c[1][1] == @c[2][1])
		win = @c[0][2] if 	@c[0][2] != ' ' && (@c[0][2] == @c[1][2] && @c[1][2] == @c[2][2]) ||	(@c[0][2] == @c[1][1] && @c[1][1] == @c[2][0])
		win = @c[1][0] if 	@c[1][0] != ' ' && (@c[1][0] == @c[1][1] && @c[1][1] == @c[1][2])
		win = @c[2][0] if 	@c[2][0] != ' ' && (@c[2][0] == @c[2][1] && @c[2][1] == @c[2][2])
		binding.pry
		case win
		when win == 'X'
			return 1
		when win == 'O'
			return 2
		end
		false
	end

	def cell(x, y, char)
		@c[x-1][y-1] = char
		check # (false si echec)
	end

end

class Player
	attr_accessor :nickname, :char

	def initialize(nickname, char_str)
		@nickname = nickname
		@char = char_str
	end
end

class Game
	attr_accessor :board, :players

	def initialize
		@players, @board = [], Board.new
		print "Player 1, what is your name ? "
		@players << Player.new(gets.chomp, 'X')
		print "Player 2, what is your name ? "
		@players << Player.new(gets.chomp, 'O')
	end

	def new_turn
		@players.each do |player|
			@board.show
			print "#{player.nickname}'s turn: Where do you want to play (2 space separated digits with line first)? "
			pos = gets.chomp.split(' ').collect {|x| x.to_i}
			winner = @board.cell(pos[0], pos[1], player.char)
			return @players[winner-1] if (winner == 1 ||  winner == 2)
		end
		false
	end

	def start
		while @board.c[0].include?(' ') || @board.c[1].include?(' ') || @board.c[2].include?(' ')
			winner = self.new_turn
			return winner if winner
		end
		false
	end
end

game = Game.new
winner = game.start
if winner then puts "\n#{winner.nickname} was obviously the best! ;)\n\n" else puts "\nDraw.\nTry again.\n\n" end
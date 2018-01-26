# Class board : La grille et son contenu, ne doit jamais être conscient du reste ( Players / Game )
class Board
	#pour pouvoir accéder à @c depuis les autres classes / espaces
	attr_accessor :c # initialement en reader mais passer en accessor pour pouvoir modifier/debugger avec pry

	# Une Cell n'ayant qu'un Id et une valeur, et un index ayant ces mêmes proprétés, pas de class Cell
	# initialise un tableau de tableaux (tableau 2D),
	# ici 3 lignes contenant chacune 3 cases (colones).
	# Utilisation :
	#		- @c 				=> array de 3 éléments (arrays)
	# 	- @c[0] 		=> élément '0'(ligne 1) de @c => array de 3 elements (strings)
	#   - @c[0][0] 	=> élément '0' (colonne 1) de @c[0] => string contenant un espace ( ' ' )
	def initialize
		@c = [ [' ',' ',' '], [' ',' ',' '], [' ',' ',' '] ] 
	end

	# Affiche ma grille. Utilisation de "\n pour les passages à la ligne et d'un mix
	# (pas propre, faut que je règle sublime) d'espaces et de tabulations pour centrer vaguement ça"
	# J'imprime directement ligne par ligne (@c[x]) avec un join pour mettre mes séparateurs
	# On pouvait aussi ajouter les numéros de ligne et début de ligne dans l'array sur l'initialize
	# ça a l'avantage de tout puts (je vous épargne les tabulations, mais ça se met dans une array aussi si y faut) avec un...
	#  puts @c.collect{ |col| col.collect {|ligne| ligne.join(" | ")}.join("\n   _________\n") (J'ai pas testé mais ça se tiens si vous suivez le truc)
	# (Oui, c'est rigolo le ruby)
	def show
		puts 	"		    1   2   3\n 		  1 #{@c[0].join(' | ')}\n 		    _________\n 		  2 #{@c[1].join(' | ')} 		\n 		    _________\n 		  3 #{@c[2].join(' | ')}\n\n"
	end

	# Oui, la répétition est flagrante, mais il est trop tard pour tenter un compactage plus profond
	# (Puis là je vérifie els 8 cas pour rien aussi >_<)
	# CHECK (return Booléen True/False pour la victoire) : Là du coup je vérifie les 8 cas possibles de victoires
	def check(char)
		win = true if 	@c[0][0] == char && ((@c[0][0] == @c[0][1] && @c[0][1] == @c[0][2]) || (@c[0][0] == @c[1][0] && @c[1][0] == @c[2][0]) || (@c[0][0] == @c[1][1] && @c[1][1] == @c[2][2]))
		win = true if 	@c[0][1] == char && (@c[0][1] == @c[1][1] && @c[1][1] == @c[2][1])
		win = true if 	@c[0][2] == char && ((@c[0][2] == @c[1][2] && @c[1][2] == @c[2][2]) ||	(@c[0][2] == @c[1][1] && @c[1][1] == @c[2][0]))
		win = true if 	@c[1][0] == char && (@c[1][0] == @c[1][1] && @c[1][1] == @c[1][2])
		win = true if 	@c[2][0] == char && (@c[2][0] == @c[2][1] && @c[2][1] == @c[2][2])
		return true if win
		false
	end

	# Cell : Tente de placer le char (pour 'character', caractère) du joueur aux coordonnées x et y (-1 puisque l'index commence à 0)
	def cell(x, y, char)
		# En cas de tentative de placement sur une case occupée, PAF ! ^^
		if @c[x-1][y-1] == ' ' then @c[x-1][y-1] = char else puts " You lost a turn trying to cheat, bastard! =D" end
		# Vérifie si ça gagne
		check(char) # (false si echec, true si win)
	end

end

# Un nom et un caractère, un joueur n'est que ça chez moi.
# Du coup une classe est inutile, un hash dans game aurait fait l'affaire
# 		@players = { name1 => 'X', name2 => 'O' }
# 			Utilisation : @players[name1] 
class Player
	attr_accessor :nickname, :char

	def initialize(nickname, char_str)
		@nickname = nickname
		@char = char_str
	end
end

class Correction # Ma classe Game, renommée pour l'occasion
	# Contient un objet Board et une array d'objets Player
	attr_accessor :board, :players

	def initialize
		# Définition de 2 variables sur une ligne
		@players, @board = [], Board.new
		# 'print' pour éviter le retour à la ligne en fin de phrase (notez l'espace pour pas coller le prompt)
		print " Player 1, what is your name ? "
		# Ajout à la liste des joueurs contenue dans mon game
		# Initialisation d'un joueur avec pour nom... ?!
		# il faut un nom => gets.chomp !
		# Il est très bien directement où nécessaire, nul besoin de le stocker dans une variable
		# En plus rien ne peut se passer sur la ligne sans lui donc le 
		#  prompt (la demande d'entrer un truc) va arriver instantanément
		@players << Player.new(gets.chomp, 'X')
		# Du coup si on vire mes commentaires, sur Joueur2 ça donne :
		print " Player 2, what is your name ? "
		@players << Player.new(gets.chomp, 'O')
	end

	# New_turn : Déroule un tour, avec un begin/rescue/end qui donne
	#  une seconde chance avant de passer le tour en cas d'erreur de frappe
	# puts un message de victoire si victoire
	def new_turn
		@players.each do |player|
			begin
				@board.show
				print " #{player.nickname}'s turn: Where do you want to play (2 space separated digits with line first)? "
				# Séparation du x et y en array et retrait de l'espace dans la foulée
				# Puis, pour chacun, transformation en int (pour 'integer', nombre entier, au
				#  lieu de la string que me récupère gets.chomp)
				pos = gets.chomp.split(' ').collect {|x| x.to_i}
				# Rappelez vous, la fonction "cell" lance "check" après avoir posé pour
				# vérifier, et retourne son résultat 
				game_ended = @board.cell(pos[0], pos[1], player.char)
			rescue
				print " STILL #{player.nickname.upcase}'s TURN: I said 2 digits separated by a space, and it goes without saying, from 1 to 3.\n
				 RTFM before your second chance : "
				pos = gets.chomp.split(' ').collect {|x| x.to_i}
				game_ended = @board.cell(pos[0], pos[1], player.char)
			end
			# Si gagné, retourne une phrase de victoire
			puts "#{@board.show}\n\n And #{player.nickname} wins! (As usual...)\n 	;)" if game_ended
			return true if game_ended
		end
		# Si pas gagné sur ce tour, retourne false
		false
	end

	# Solve : Déroule la partie jusqu'au bout
	# Retourne si victoire de qulqu'un, ou puts un
	# message en cas d'égalité, càd sortie du while sans victoire (tableau plein)
	def solve
		while ( @board.c[0].include?(' ') || @board.c[1].include?(' ') || @board.c[2].include?(' ') )
			# Self.new_turn, "self." et non @ car fonction qu'on veut lancer dessus
			# et non variable à laquelle on veut accéder
			winner = self.new_turn
			return if winner
		end
		puts "#{@board.show}\n\n Draw.\nTry again.\n\n"
	end
end

Correction.new.solve
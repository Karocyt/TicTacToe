class OrangeTree
	attr_accessor :age, :height, :oranges, :id, :birth_year
	@@year = 2017
	@@trees = []

	def initialize(height)
		@height = height
		@birth_year = @@year
		@oranges = 0
		@@trees << self
		@id = @@trees.length # pour augmenter de 1 à chaque arbre en commençant à 1
		puts "Tree #{self.id} planted, 5 years before your first fruits !"
	end

	def age() @@year - @birth_year end # Juste pour le one-liner ;)

	def self.one_year_passes()
		@@year += 1
		@@trees.each do |tree|
			puts "\n#{tree.id}: #{tree.age} yrs}"
			if tree.age < 50
				tree.height += 1
				tree.oranges = 20 + tree.age if tree.age >= 5
			else
				tree.height = 0
				tree.oranges = 0
			end
			puts tree.inspect
		end
		puts "One year passes...\nTrees are growing taller, new fruits slowly appear!"
	end

	def pick_an_orange()
		@oranges -= 1 if @oranges > 0
		puts "#{@oranges} picked in tree #{@id}"
	end

	def self.count_the_oranges()
		count = 0
		@@trees.each { |tree| count += tree.oranges }
		unless count == 0 then "		  #{count} oranges" else "		  No fruits" end
	end
end

# ma fonction de nettoyage, notez qu'il doit y avoir un truc dédié ^^'
def screen_break() puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"end

def menu
	print "---------<< WELCOME TO THE SIMS BOUSEUX EDITION >>---------\n
			- Year: #{OrangeTree.class_variable_get(:@@year)} -
	#{OrangeTree.count_the_oranges}\n
	Choose your action :
	1 - Wait until next year
	2 - Plant a new 3 years old tree
	3 - Pick orange
	0 - Kill yourself\n
	What will it be today ? "
	choice = gets.to_i
end

def input_management(choice)
	case choice
	when 1
		OrangeTree.one_year_passes
	when 2
		OrangeTree.new(12)
	when 3
		# Accède à tous les objets de type OrangeTree dans l'espace de travail 
			# Les affiche si taille différente de 0 (si pas crevés)
		# Cueille une orange sur le tree qui a l'id voulu par l'user
		ObjectSpace.each_object(OrangeTree) { |tree| puts "#Tree #{tree.id}: #{tree.height} ft, planted in #{tree.birth_year}, #{tree.oranges} oranges to pick." if tree.height > 0}
		print "Which tree do you want to pick (numeric): "
		choice = gets.to_i
		screen_break()
		ObjectSpace.each_object(OrangeTree) { |tree| tree.pick_an_orange if tree.id == choice }
	when 0
		return false
	else
		# Si choix innatendu :
		puts "It seems you missed-typed..."
	end
	true
end


screen_break()

# Game Loop
	# menu = puts du menu, gets.to_i du choix (renvoie un entier)
	# input_management = traitement du choix, renvoie false si choix = suicide, true sinon.
while OrangeTree.class_variable_get(:@@year) < 2070
	break unless input_management(menu)
	screen_break
end

puts "[...]\n\n 	[...]\n\n\n 		[...]\n\n\n\n 			You died.\n\n"
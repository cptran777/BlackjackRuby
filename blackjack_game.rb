#Filename: blackjack_game.rb
#Created by: Charlie Tran
#This file emulates a text based game of blackjack in the terminal.

class Deck		#Class for the current deck in play

	@cards_indeck = { #Hashmap for cards in deck. 
		#First value is to display name
		#Second value is the value vto add to the cards in play
		#Third value, true = in deck, false = in play
		1 => ["Ace of Spades", 11, true],
		2 => ["Two of Spades", 2, true],
		3 => ["Three of Spades", 3, true],
		4 => ["Four of Spades", 4, true],
		5 => ["Five of Spades", 5, true],
		6 => ["Six of Spades", 6, true],
		7 => ["Seven of Spades", 7, true],
		8 => ["Eight of Spades", 8, true],
		9 => ["Nine of Spades", 9, true],
		10 => ["Ten of Spades", 10, true],
		11 => ["Jack of Spades", 10, true],
		12 => ["Queen of Spades", 10, true],
		13 => ["King of Spades", 10, true],
		14 => ["Ace of Hearts", 11, true],
		15 => ["Two of Hearts", 2, true],
		16 => ["Three of Hearts", 3, true],
		17 => ["Four of Hearts", 4, true],
		18 => ["Five of Hearts", 5, true],
		19 => ["Six of Hearts", 6, true],
		20 => ["Seven of Hearts", 7, true],
		21 => ["Eight of Hearts", 8, true],
		22 => ["Nine of Hearts", 9, true],
		23 => ["Ten of Hearts", 10, true],
		24 => ["Jack of Hearts", 10, true],
		25 => ["Queen of Hearts", 10, true],
		26 => ["King of Hearts", 10, true],
		27 => ["Ace of Clubs", 11, true],
		28 => ["Two of Clubs", 2, true],
		29 => ["Three of Clubs", 3, true],
		30 => ["Four of Clubs", 4, true],
		31 => ["Five of Clubs", 5, true],
		32 => ["Six of Clubs", 6, true],
		33 => ["Seven of Clubs", 7, true],
		34 => ["Eight of Clubs", 8, true],
		35 => ["Nine of Clubs", 9, true],
		36 => ["Ten of Clubs", 10, true],
		37 => ["Jack of Clubs", 10, true],
		38 => ["Queen of Clubs", 10, true],
		39 => ["King of Clubs", 10, true],
		40 => ["Ace of Diamonds", 11, true],
		41 => ["Two of Diamonds", 2, true],
		42 => ["Three of Diamonds", 3, true],
		43 => ["Four of Diamonds", 4, true],
		44 => ["Five of Diamonds", 5, true],
		45 => ["Six of Diamonds", 6, true],
		46 => ["Seven of Diamonds", 7, true],
		47 => ["Eight of Diamonds", 8, true],
		48 => ["Nine of Diamonds", 9, true],
		49 => ["Ten of Diamonds", 10, true],
		50 => ["Jack of Diamonds", 10, true],
		51 => ["Queen of Diamonds", 10, true],
		52 => ["King of Diamonds", 10, true]
	}

	@num_cards = 52

	attr_accessor :cards_indeck
	attr_accessor :num_cards

	def initialize
	end

	class << self

		def cards_indeck()
			@cards_indeck
		end

		def check_deck(num) #This and below function work together.
		#This function tests the selected card by key. 
			if @cards_indeck[num][2] == true #True = still in deck, allow pull.
				return 1
			else
				return 0 #If not true, card has been played. Return 0 to let choosecard function know to pick again.
			end
		end

		def shuffle	#Resets all cards in deck to "true" effectively putting them back in the deck
			for x in 1..52
				@cards_indeck[x][2] = true
			end
			@num_cards = 52
		end

		def draw_card #Creates the loop to pick a card for the player.
			check_switch = 0 #Sets switch to default value
			until check_switch == 1 	#1 = Card is still in deck
				x = 1 + rand(52)	#Draws a random card
				check_switch = self.check_deck(x)	#Sets switch to 1 if card exists, 0 if not and repeats loop
				if @num_cards <= 0
					puts "Shuffling cards back into the deck..."
					Deck.shuffle
				end
			end
			@cards_indeck[x][2] = false	#Sets card to false as it will be drawn from deck.
			@num_cards -= 1
			return @cards_indeck.keys[x-1] #Returns key so that player class function can add card to player's pile
		end		
	end

end

class Player	#Class for player and any NPCs

	attr_reader :name
	attr_accessor :wallet
	attr_accessor :cards_inplay
	attr_accessor :inplay_value
	attr_accessor :post_size

	def initialize(name, funds = 50000) #sets player name and default beginning funds
		@name = name
		@wallet = funds
		@cards_inplay = {}
		@inplay_value = 0
		@pot_size = 0
	end

	def display_funds	#Displays current available money.
		puts "You currently have $#{@wallet}."
	end

	def funds_call		#Returns the current funds.
		return @wallet
	end

	def place_bet		#Places a bet into the pot
		valid_check = false		#Switch checks bet for valid amount
		until valid_check == true #Move on once player chooses a valid amount
			puts "Please select amount to bet."
			@bet = gets.chomp.to_i #Gets amount and changes to integer.
			if @bet <= 0
				puts "Invalid amount. Please try again."
			else
				valid_check = true #Exits until loop
			end
		end
		@wallet -= @bet #Reduces current funds by the bet amount
		return @bet
	end

	def play_card		#Utilizes draw_card in Deck class to put a card into play for player.
		x = Deck.draw_card
		@cards_inplay[x] = Deck.cards_indeck[x]
		@inplay_value += @cards_inplay[x][1]
	end

	def inplay_clear
		@cards_inplay.clear
		@inplay_value = 0
	end

	def disp_inplay 	#Displays the value of the in play cards
		puts "You are at #{@inplay_value}!"
		puts "#{@cards_inplay}"
	end

	def check_status	#Checks the pile value and returns value
		#Tells whether the player is still under 21, at 21, or has busted. 
		return case @inplay_value <=> 21
		when 0 then 0
		when 1 then 1
		when -1 then -1
		end
	end

	def add(amount)
		@pot_size += amount
		puts "$#{amount} added to your bet. There is currently #{@pot_size} at stake!"
	end

	def winnings_blackjack(amount)
		@wallet += @pot_size * 2.5
		puts "You just earned $#{amount} for Blackjack!!"
		@pot_size = 0
	end

	def winnings_victory(amount)
		@wallet += @pot_size * 2
		puts "You just earned $#{amount}! Congratulations!"
	end

	def menu
		puts "What would you like to do? Type to select choice: "
		puts "Hit"
		puts "Stand"
		puts "Split"
		choice = gets.chomp
	end

end


dealer = Player.new("Dealer", 0)
puts "Welcome to BlackJack Arena! What is your name?"
input_name = gets.chomp
my_char = Player.new(input_name)

my_char.disp_inplay


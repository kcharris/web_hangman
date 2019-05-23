
require "yaml"

module Hangman
  class Game
    attr_accessor :word_to_guess, :answer_board, :guessed_letters, :guesses_left

    def initialize
      @dictionary_array = []
      dictionary_file = File.open("5desk.txt", "r")
      @dictionary_array = dictionary_file.readlines
      @dictionary_size = @dictionary_array.length
      self.new_game
    end

    def new_game
      @word_to_guess = @dictionary_array[rand(@dictionary_size)]
      @word_to_guess = @word_to_guess[/[a-zA-Z]+/].downcase
      @answer_board = "_" * @word_to_guess.length
      @guessed_letters = ""
      @guesses_left = 8
    end

    def game_prompt
      puts "Guesses left: #{@guesses_left} Guessed letters: #{@guessed_letters}"
      puts @answer_board
      puts "Enter a letter. Type save to save or load to load"
    end

    def input_processor(player_choice)
      if player_choice =~ /^[a-zA-Z]$/
        if (@word_to_guess.include? (player_choice.downcase)) && !(@answer_board.include? (player_choice.downcase))
          @word_to_guess.split("").each_with_index do |letter, index|
            if letter == player_choice.downcase
              @answer_board[index] = letter
            end
          end
          if @answer_board == @word_to_guess
            puts "You guessed #{@word_to_guess} correctly!\n"
            self.new_game
          end
        else
          if !(@guessed_letters.include? (player_choice.downcase)) && !(@answer_board.include? (player_choice.downcase))
            @guessed_letters += player_choice
            @guesses_left -= 1
            if @guesses_left == -1
              puts "You lose, the word was #{@word_to_guess}"
              self.new_game
            end
          end
        end
      end
    end
  end

  class Player
    attr_reader :choice

    def choose
      @choice = gets.chomp
      until @choice =~ /^[a-zA-Z]$|^save$|^load$/
        puts "Enter a valid input"
        @choice = gets.chomp
      end
    end
  end

  def save(game, player_choice)
    if player_choice == "save"
      puts "saved"
      hash = {
        wtg: game.word_to_guess,
        ab: game.answer_board,
        gletters: game.guessed_letters,
        gleft: game.guesses_left,
      }
      File.write("save_file.yaml", YAML::dump(hash))
    end
  end

  def load(game, player_choice)
    if player_choice == "load"
      puts "loaded"
      hash = YAML::load(File.read("save_file.yaml"))
      game.word_to_guess = hash[:wtg]
      game.answer_board = hash[:ab]
      game.guessed_letters = hash[:gletters]
      game.guesses_left = hash[:gleft]
    end
  end
end

# include Hangman
# game = Game.new
# player = Player.new
# while true
#   game.game_prompt
#   player.choose
#   save(game, player.choice)
#   load(game, player.choice)
#   game.input_processor(player.choice)
# end

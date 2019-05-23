require "sinatra"
require "sinatra/reloader"
require "./lib/hangman.1.rb"

include Hangman
game = Game.new
player = Player.new

get "/" do
  prompt = game.game_prompt
  erb :index, :locals => {:prompt => prompt, :word_to_guess => word_to_guess,
                          :current_guess => current_guess, :answer_board => answer_board,
                          :guesses_left => guesses_left, :output => output}
end

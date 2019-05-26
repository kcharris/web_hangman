require "sinatra"
require "sinatra/reloader"
require "./lib/hangman.rb"

include Hangman

enable :sessions

game = Game.new
game.new_game

post "/" do
  game.guesses_left = session[:guesses_left]
  game.guessed_letters = session[:guessed_letters]
  game.answer_board = session[:answer_board]
  game.word_to_guess = session[:word_to_guess]
  game.game_over = session[:game_over]
  game.win = session[:win]
end

get "/" do
  if params["guess"] != nil
    game.input_processor(params["guess"])
  end
  unless params["guess"] =~ /^[a-zA-Z]$/
    @error = true
  else
    @error = false
  end
  if params["cheat"]
    cheat = true
  else
    cheat = false
  end
  session[:guesses_left] = game.guesses_left
  session[:guessed_letters] = game.guessed_letters
  session[:answer_board] = game.answer_board
  session[:word_to_guess] = game.word_to_guess
  session[:game_over] = game.game_over
  session[:win] = game.win
  erb :index, :locals => {:guesses_left => game.guesses_left,
                          :error => @error, :guessed_letters => game.guessed_letters,
                          :answer_board => game.answer_board, :word_to_guess => game.word_to_guess,
                          :game_over => game.game_over, :win => game.win, :cheat => cheat}
end

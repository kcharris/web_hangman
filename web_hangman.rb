require "sinatra"
require "sinatra/reloader"
require "./lib/hangman.rb"

include Hangman

enable :sessions

game = Game.new
game.new_game

get "/" do
  if params["guess"] != nil
    game.input_processor(params["guess"])
  end
  unless params["guess"] =~ /^[a-zA-Z]$/ || ""
    @error = true
  else
    @error = false
  end
  if params["cheat"]
    cheat = true
  else
    cheat = false
  end
  if game.game_over
    redirect "/result"
  end
  erb :index, :locals => {:guesses_left => game.guesses_left,
                          :error => @error, :guessed_letters => game.guessed_letters,
                          :answer_board => game.answer_board, :word_to_guess => game.word_to_guess,
                          :game_over => game.game_over, :win => game.win, :cheat => cheat}
end
get "/result" do
  erb :result, :locals => {game_over: game.game_over, win: game.win, word_to_guess: game.word_to_guess}
end

get "/newgame" do
  game.new_game
  redirect "/"
end

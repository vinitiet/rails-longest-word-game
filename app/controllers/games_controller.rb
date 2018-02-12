require 'open-uri'
require 'json'

class GamesController < ApplicationController

  # def current_score
  #   @_current_score = session[:current_scorescore]
  # end

  def new
    @letters = ("A".."Z").to_a.sample(10)
    unless session[:current_scorescore]
      @score = 0
      session[:current_scorescore] = 0
    else
      @score = session[:current_scorescore]
    end
  end

  def score
    @letters = params[:letters].split
    @input = params[:word]
    @message = "Sorry but #{@input} can't be build out of @letters.join(", ")" unless letters_in_grid?(@input, @letters)
    unless JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@input}").read)["found"]
      @message = "Sorry but #{@input} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{@input} is a valid English word!"
      session[:current_scorescore] += @input.length ** 2
      @score = session[:current_scorescore]
    end

  end

  private

  def letters_in_grid?(word, grid)
    letters = grid.dup
    return false unless word
    word.upcase.chars.each do |char|
      return false unless letters.include? char
      letters.delete_at(letters.find_index(char))
    end
    return true
  end
end

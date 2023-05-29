require 'open-uri'

class GameController < ApplicationController
  def new
    @words = Array.new((5..12).to_a.sample) { ('A'..'Z').to_a.sample }
    session[:words] = @words
  end

  def score
    @res = params[:res]
    @words = session[:words]
    @outcome = score_and_message(@res, @words)
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def score_and_message(word, words)
    grid = @words.join
    if included?(word, grid)
      if english_word?(word)
        return "Congratulations! #{@res} is a valid word."
      else
        return "Sorry, but #{@res} cannot be built from #{@words}."
      end
    else
      return "Sorry, but #{@res} is not an English word."
    end
  end
end

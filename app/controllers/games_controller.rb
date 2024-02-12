require 'open-uri'

class GamesController < ApplicationController

  def new
    grid = []
    10.times do
      grid << ("A".."Z").to_a.sample
    end
    @grid = grid
  end

  def score
    @input = params[:answer]
    @grid = params[:grid].split
    grid_for_check = @grid.dup

    url = "https://wagon-dictionary.herokuapp.com/#{@input}"
    answer = URI.open(url).read
    parsed = JSON.parse(answer)
    input_is_a_word = parsed["found"]
    word_is_in_grid = nil

    @input.chars.each do |letter|
      if grid_for_check.include?(letter.upcase)
        grid_for_check.delete_at(grid_for_check.index(letter.upcase))
      end
    end

    word_is_in_grid = @grid.length - @input.length == grid_for_check.length

    if word_is_in_grid && input_is_a_word
      @answer = "Congratulations #{@input} is a valid English word!"
    elsif word_is_in_grid && !(input_is_a_word)
      @answer = "Sorry but #{@input} does not seem to be a valid English word!"
    else
      @answer = "Sorry but #{@input} can't be built out of #{@grid}"
    end
  end
end

require 'json'
require 'open-uri'
require 'pry-byebug'

class GamesController < ApplicationController
  def new
    ten_letters = []
    10.times { ten_letters << ('a'..'z').to_a.sample }
    @letters = ten_letters
  end

  def score
    @guess = params[:guess]
    @letters = params[:letters]
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    raw_json = open(url).read
    data = JSON.parse(raw_json)
    @found = data['found']
    result = nil
    if all_in_grid?(array_to_hash(@letters.scan(/\w/)), array_to_hash(@guess.scan(/\w/)))
      @found == false ? result = 'grid_non_word' : result = 'grid_word'
    else
      result = 'non_grid'
    end
    @result = result
  end

  def array_to_hash(array)
    hash = {}
    array.each do |letter|
      if hash[letter].nil?
        hash[letter] = 1
      else
        hash[letter] += 1
      end
    end
    return hash
  end

  def all_in_grid?(grid_hash, guess_hash)
    not_in_grid = 0
    guess_hash.each do |letter, reps|
      if grid_hash[letter].nil?
        not_in_grid += 1
      elsif grid_hash[letter] < reps
        not_in_grid += (reps - grid_hash[letter])
      end
    end
    return not_in_grid.zero?
  end

end

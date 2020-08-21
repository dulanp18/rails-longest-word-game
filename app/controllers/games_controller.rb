class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    letters = ('A'..'Z').to_a
    @sample = letters.sample(10)
  end

  def score
    @word = params[:word]
    @original_sample = params[:sample].split
    if !out_of_grid(@original_sample, @word)
      @result = "Sorry but #{@word} cant be built out of #{params[:sample]}"
    elsif !valid_word(@word)
      @result = "Sorry but #{@word} does not seem to be a valid English word"
    else
      @result = "Congratulations! #{@word} is a valid English word!"
    end
  end

  def out_of_grid(sample, word)
    dict_sample = {}
    dict_word = {}
    sample.each do |letter|
      if dict_sample.key?(letter)
        dict_sample[letter.downcase] += 1
      else
        dict_sample[letter.downcase] = 1
      end
    end
    word.each_char do |letter|
      if dict_word.key?(letter)
        dict_word[letter.downcase] += 1
      else
        dict_word[letter.downcase] = 1
      end
    end
    dict_word.each do |key, value|
      return false if dict_sample[key].nil?
      return false if dict_sample[key] < value
    end
    true
  end

  def valid_word(word)
    request_uri = 'https://wagon-dictionary.herokuapp.com/'
    url = "#{request_uri}#{word}"
    content = open(url).read
    details = JSON.parse(content)
    details['found'] == true ? true : false
  end
end

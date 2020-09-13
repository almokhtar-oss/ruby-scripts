#!/usr/bin/env ruby

require 'json'
require 'uri'
require 'net/http'

def movie

  api_key = ENV['OMDBAPI_API_KEY'] || 'fbca6ced'
  movie_name = ARGV

  if movie_name == 'q' || movie_name == nil
    puts
    exit(1)
  else
    uri = URI("http://www.omdbapi.com/?t=#{movie_name}&apikey=#{api_key}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
  end

  if data['Response'] == 'False'
    puts "no movie found by name: #{movie_name}"
    exit(1)
  else
    begin
      title = data['Title']
      year = data['Year']
      title = data['Title']
      released = data['Released']
      runtime = data['Runtime']
      genre = data['Genre']
      actors = data['Actors']
      director = data['Director']
      plot = data['Plot']
      imdb_rating = data['imdbRating']
      production = data['Production']
      awards = data['Awards']
      country = data['Country']
      language = data['Language']
      score = data['Ratings'][1]['Value']
    rescue
      score = 'No score found'
    end

    puts '+++++++++++++++++++++++++++++++++++++++++++++++'
    puts "| Title: #{title}"
    puts "| Year: #{year}"
    puts "| Runtime: #{runtime}"
    puts "| Tomato: #{score}"
    puts "| Date Released: #{released}"
    puts "| Genre: #{genre}"
    puts "| Director: #{director}"
    puts "| Actors: #{actors}"
    puts "| Plot: #{plot}"
    puts "| imdbRating: #{imdb_rating}"
    puts "| Awards: #{awards}"
    puts "| Country: #{country}"
    puts "| Production: #{production}"
    puts "| Language: #{language}"
    puts '+++++++++++++++++++++++++++++++++++++++++++++++'
  end
end

movie
require 'open-uri'
require 'nokogiri'
require 'pry'

module StarWarsComics
end

module Concerns
end

require_relative 'star-wars-comics/concerns/findable.rb'

require_relative 'star-wars-comics/artist.rb'
require_relative 'star-wars-comics/artists.rb'
require_relative 'star-wars-comics/cli.rb'
require_relative 'star-wars-comics/issue.rb'
require_relative 'star-wars-comics/scraper.rb'
require_relative 'star-wars-comics/series.rb'

BASE_PATH = "http://starwars.wikia.com"

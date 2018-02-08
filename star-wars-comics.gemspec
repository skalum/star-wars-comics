# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative './lib/star-wars-comics/version'

Gem::Specification.new do |s|
  s.name        = 'star-wars-comics'
  s.version     = StarWarsComics::VERSION
  s.licenses    = ['MIT']
  s.summary     = "CLI for info about canon Star Wars comics"
  s.description = "Much longer explanation coming soon..."
  s.authors     = ["Sam Kalum"]
  s.email       = 'stkalum@gmail.com'
  s.files       = ["lib/star-wars-comics.rb", "lib/star-wars-comics/artist.rb", "lib/star-wars-comics/artists.rb", "lib/star-wars-comics/cli.rb", "lib/star-wars-comics/issue.rb", "lib/star-wars-comics/scraper.rb", "lib/star-wars-comics/series.rb", "lib/star-wars-comics/version.rb", "lib/star-wars-comics/concerns/findable.rb", ]
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})
  s.metadata    = { "source_code_uri" => "https://github.com/skalum/star-wars-comics" }
  s.executables << 'star-wars-comics'

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "pry"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
end

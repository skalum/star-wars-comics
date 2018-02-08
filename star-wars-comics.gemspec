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
  s.metadata    = { "source_code_uri" => "https://github.com/skalum/star-wars-comics" }
  s.executables << 'star-wars-comics'
end

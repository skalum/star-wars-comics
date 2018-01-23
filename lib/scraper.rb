require 'open-uri'
require 'nokogiri'

class Scraper

  def self.scrape_series(path)
    titles = Nokogiri::HTML(open(path)).css("tr td b font[size=\"3\"]")

    titles.each do |title|
      puts title.text.strip
    end
  end

end

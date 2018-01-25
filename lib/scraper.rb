require 'open-uri'
require 'nokogiri'

class Scraper

  def self.scrape_series(path)
    titles = Nokogiri::HTML(open(path)).css("div.CategoryTreeSection a")

    titles.each do |title|
      Series.find_or_create_by_name(title.text.strip).url = title["href"]
    end
  end

  def self.scrape_issues(path)
    issues = Nokogiri::HTML(open(path)).css("div.mw-content-ltr ul li a")

    issues.each do |issue|
      if issue.text.match?(/Star\sWars\s\d+.*/)
        puts issue.text
        # Issues.find_or_create_by_name(issue.text.strip.url) = issue["href"]
      end
    end

  end

end

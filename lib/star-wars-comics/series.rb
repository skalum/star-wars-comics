class StarWarsComics::Series
  extend Concerns::Findable

  attr_accessor :name, :start_date, :end_date, :status, :stories, :path,
                :issues, :desc

  def initialize(name = nil, path = nil)
    @name = name
    @path = path
    @issues = []
  end

  def add_issue(issue)
    issue.series ||= self
    self.issues << issue unless self.issues.include?(issue)
  end

  def self.all
    @@all ||= StarWarsComics::Scraper::scrape_series("/wiki/Category:Canon_comics", [])
  end

end

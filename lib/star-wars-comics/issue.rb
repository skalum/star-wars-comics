class StarWarsComics::Issue
  extend Concerns::Findable

  attr_accessor :name, :path, :pub_date, :pages, :next_issue, :last_issue

  attr_reader :series, :writer, :penciller, :letterer, :colorist

  @@all = []

  def initialize(name = nil, path = nil)
    @name = name
    @path = path
    @writer = nil
    @penciller = nil
    @letterer = nil
    @colorist = nil
    @next_issue = nil
    @last_issue = nil
    StarWarsComics::Scraper.scrape_issue_info(self)
  end

  def series=(series)
    @series = series
    series.add_issue(self)
  end

  def writer=(writer)
    @writer = writer
    writer.add_issue(self)
  end

  def penciller=(penciller)
    @penciller = penciller
    penciller.add_issue(self)
  end

  def letterer=(letterer)
    @letterer = letterer
    letterer.add_issue(self)
  end

  def colorist=(colorist)
    @colorist = colorist
    colorist.add_issue(self)
  end

  def add_issue(issue)
    self.issues << issue unless self.issues.include?(issue)
  end

  def self.all
    @@all
  end

end

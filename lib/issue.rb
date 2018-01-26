class Issue
  include Concerns::Memorable::InstanceMethods
  extend Concerns::Memorable::ClassMethods

  extend Concerns::Findable

  attr_accessor :name, :series, :path, :writer, :penciller, :letterer,
                :colorist, :pub_date, :pages

  @@all = []

  def initialize(name, path)
    super
    Scraper.scrape_issue_info(self)
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

  def self.all
    @@all
  end

end

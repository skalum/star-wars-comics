class Issue
  include Concerns::Memorable::InstanceMethods
  extend Concerns::Memorable::ClassMethods

  extend Concerns::Findable

  attr_accessor :name, :path, :pub_date, :pages

  attr_reader :series, :writer, :penciller, :letterer, :colorist

  @@all = []

  def initialize(name, path)
    super
    @writer = []
    @penciller = []
    @letterer = []
    @colorist = []
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

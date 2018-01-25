class Issue
  include Concerns::Memorable::InstanceMethods
  extend Concerns::Memorable::ClassMethods

  extend Concerns::Findable

  attr_accessor :name, :url, :writer, :penciller, :colorist, :pub_date, :pages

  @@all = []

  def initialize(name)
    super
    Scraper.scrape_issue_info(self)
  end

  def writer=(writer)
    self.writer = writer
    writer.add_issue(self)
  end

  def penciller=(penciller)
    self.penciller = penciller
    penciller.add_issue(self)
  end

  def colorist=(colorist)
    self.colorist = colorist
    colorist.add_issue(self)
  end

  def self.all
    @@all
  end

end

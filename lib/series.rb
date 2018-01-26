class Series
  include Concerns::Memorable::InstanceMethods
  extend Concerns::Memorable::ClassMethods

  extend Concerns::Findable

  attr_accessor :name, :start_date, :end_date, :status, :stories, :path, :issues

  @@all = []

  def initialize(name, path)
    super
    @issues = []
  end

  def add_issue(issue)
    issue.series ||= self
    super
  end

  def self.all
    @@all
  end

end

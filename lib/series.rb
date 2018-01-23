class Series
  include Concerns::Memorable::InstanceMethods
  extend Concerns::Memorable::ClassMethods

  extend Concerns::Findable

  attr_reader :name, :start_date, :end_date, :status, :stories, :url

  @@all = []

  def initialize(name)
    super
    @stories = []
    @status = "ongoing"
  end

  def self.all
    @@all
  end

end

class Artist
  include Concerns::Memorable::InstanceMethods
  extend Concerns::Memorable::ClassMethods

  extend Concerns::Findable

  attr_accessor :name, :issues

  @@all = []

  def initialize(name)
    super
    @issues = []
  end

  def stories
    self.issues.collect {|issue| issue.story}.uniq
  end

  def self.all
    @@all
  end

end

class Artist
  include Concerns::Memorable::InstanceMethods
  extend Concerns::Memorable::ClassMethods

  extend Concerns::Findable

  attr_accessor :name, :issues, :path

  @@all = []

  def initialize(name, path)
    super
    @issues = []
  end

  def add_issue(issue)
    artist_var = self.class.to_s.sub("Artists::", "").downcase
    issue.send("#{artist_var}") || issue.send("#{artist_var}=", self)
    super
  end

  def stories
    self.issues.collect {|issue| issue.story}.uniq
  end

  def self.all
    @@all
  end

end

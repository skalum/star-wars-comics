class StarWarsComics::Artist
  extend Concerns::Findable

  attr_accessor :name, :issues, :path

  @@all = []

  def initialize(name = "", path = "")
    @name = name
    @path = path
    @issues = []
  end

  def add_issue(issue)
    artist_var = self.class.to_s.sub("StarWarsComics::Artists::", "").downcase
    issue.send("#{artist_var}") || issue.send("#{artist_var}=", self)
    self.issues << issue unless self.issues.include?(issue)
  end

  def frequent_collaborators
    collabs_hist = {}

    self.issues.each do |issue|
      if collabs_hist.has_key?(issue.writer)
        collabs_hist[issue.writer] += 1
      elsif issue.writer != self
        collabs_hist[issue.writer] = 0
      end

      if collabs_hist.has_key?(issue.penciller)
        collabs_hist[issue.penciller] += 1
      elsif issue.penciller != self
        collabs_hist[issue.penciller] = 0
      end

      if collabs_hist.has_key?(issue.letterer)
        collabs_hist[issue.letterer] += 1
      elsif issue.letterer != self
        collabs_hist[issue.letterer] = 0
      end

      if collabs_hist.has_key?(issue.colorist)
        collabs_hist[issue.colorist] += 1
      elsif issue.colorist != self
        collabs_hist[issue.colorist] = 0
      end

    end

    collabs_hist.sort_by {|collab, times| times}.each do |collab, times|
      puts "#{collab.name}: #{times} times" unless times < 2
    end

  end

  def self.sort_alpha
    self.all.sort_by! {|artist| artist.name}
  end

  def self.all
    @@all
  end

end

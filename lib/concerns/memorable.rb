module Concerns::Memorable

  module ClassMethods

    def create(name, path)
      obj = self.new(name, path)
      obj.save

      obj
    end

    def destroy_all
      self.all.clear
    end

  end

  module InstanceMethods

    def initialize(name, path)
      self.name = name
      self.path = path
    end

    def save
      self.class.all << self
    end

    def add_issue(issue)
      self.issues << issue unless self.issues.include?(issue)
    end

  end

end

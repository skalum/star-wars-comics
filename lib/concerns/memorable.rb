module Concerns::Memorable

  module ClassMethods

    def create(name)
      object = self.new(name)
      object.save

      object
    end

    def destroy_all
      self.all.clear
    end

  end

  module InstanceMethods

    def initialize(*args)
      self.name = args[0]
    end

    def save
      self.class.all << self
    end

  end

end

module Concerns::Findable

  def find_or_create_by_name(name, path)
    self.find_by_name(name) || self.create(name, path)
  end

  def find_by_name(name)
    self.all.detect {|obj| obj.name.downcase == name.downcase}
  end

end

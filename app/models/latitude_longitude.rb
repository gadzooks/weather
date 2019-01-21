require 'singleton'
class LatitudeLongitude
  include Singleton
  attr_reader :locations

  FILENAME = 'app/models/data/latitude_longitudes.yml'
  YAML_DATA = YAML::load(File.open(FILENAME))

  Location = Struct.new(:name, :description, :latitude, :longitude) do
    def ==(other)
      self.class == other.class && other.name == name
    end

    alias eql? ==

    def hash
      name.hash
    end
  end

  def self.instance
    @@instance ||= new
  end

  def initialize
    @locations = {}

    YAML_DATA.each do |y|
      name = y.first
      hsh = y.second
      @locations[name] = Location.new(name, hsh['description'], hsh['latitude'],
                                      hsh['longitude'])
    end
  end

  def all_places
    @locations.values
  end

  def convert(names)
    names.map { |n| @locations[n] }
  end

end


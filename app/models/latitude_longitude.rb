require 'singleton'
class LatitudeLongitude
  include Singleton
  attr_reader :locations

  FILENAME = 'app/models/data/latitude_longitudes.yml'
  YAML_DATA = YAML::load(File.open(FILENAME))

  Location = Struct.new(:name, :description, :latitude, :longitude)

  def self.instance
    @@instance ||= new
  end

  def initialize
    @locations = []

    YAML_DATA.each do |y|
      name = y.first
      hsh = y.second
      puts hsh.inspect
      @locations << Location.new(name, hsh['description'], hsh['latitude'],
                                 hsh['longitude'])
    end
  end

end


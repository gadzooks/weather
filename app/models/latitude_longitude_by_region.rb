require 'singleton'
class LatitudeLongitudeByRegion
  include Singleton
  attr_reader :locations, :regions

  YAML_REGION_DATA = YAML::load(File.open('app/models/data/wta_search_regions.yml'))
  YAML_LOCATION_DATA = YAML::load(File.open('app/models/data/regional_lat_long.yml'))

  Location = Struct.new(:name, :description, :latitude, :longitude, :region, :sub_region)
  Region = Struct.new(:name, :search_key, :description)

  def self.instance
    @@instance ||= new
  end

  def initialize
    @locations = {}
    @regions = ActiveSupport::OrderedHash.new

    YAML_LOCATION_DATA.each do |y|
      name = y.first
      hsh = y.second
      @locations[name] = Location.new(name, hsh['description'], hsh['latitude'],
                                      hsh['longitude'], hsh['region'], hsh['sub_region'])
    end

    YAML_REGION_DATA.each do |y|
      name = y.first
      hsh = y.second
      Rails.logger.info y.inspect
      @regions[name] = Region.new(name, hsh['search_key'], hsh['description'])
    end

  end

  def all_places
    @locations.keys
  end

  def region_for_location(location)
    @regions[location]
  end

  def convert(names)
    names.map { |n| @locations[n] }
  end

end



require 'singleton'
class LatitudeLongitudeByRegion
  include Singleton
  attr_reader :locations, :regions

  YAML_REGION_DATA = YAML::load(File.open('app/models/data/wta_search_regions.yml'))
  YAML_LOCATION_DATA = YAML::load(File.open('app/models/data/regional_lat_long.yml'))

  Location = Struct.new(:name, :description, :latitude, :longitude, :region, :sub_region) do
    def ==(other)
      self.class == other.class && other.name == name
    end

    alias eql? ==

    def hash
      name.hash
    end
  end

  Region = Struct.new(:name, :search_key, :description) do
    def ==(other)
      self.class == other.class && other.name == name
    end

    alias eql? ==

    def hash
      name.hash
    end

    def wta_trip_report_url
      "https://www.wta.org/go-outside/trip-reports/tripreport_search?title=&region=#{search_key}&subregion=all&searchabletext=&author=&startdate=&_submit=&enddate=&_submit=&month=all&format=list&filter=Search"
    end
  end

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

  def all_regions
    @regions
  end

  def region_for_location(location)
    region_name = location
    region_name = location.region if location.respond_to? :region
    @regions[region_name]
  end

  def convert(names)
    names.map { |n| @locations[n] }
  end

end



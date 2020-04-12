require 'rails_helper'

RSpec.describe LatitudeLongitudeByRegion, type: :model do

  context LatitudeLongitudeByRegion::Location do
    it "should verify two locations with same name as equal" do
      loc1 = LatitudeLongitudeByRegion::Location.new('foo', 'desc', 1234, -1234)
      loc2 = LatitudeLongitudeByRegion::Location.new('foo', 'some desc', 5555, -5555)

      expect(loc1).to eql(loc1)
      expect(loc1).to eql(loc2)
    end

    it "should verify two locations with different name as NOT equal" do
      loc1 = LatitudeLongitudeByRegion::Location.new('foo', 'desc', 1234, -1234)
      loc2 = LatitudeLongitudeByRegion::Location.new('bar', 'desc', 1234, -1234)

      expect(loc1).not_to eql(loc2)
    end

  end

end

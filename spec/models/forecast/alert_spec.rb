require 'rails_helper'

RSpec.describe Forecast::Alert, type: :model do

  context Forecast::Alert do
    it "should show two alerts with same title as equal" do
      alert1 = Forecast::Alert.new(title: 'matching title', description: '11111')
      alert2 = Forecast::Alert.new(title: 'matching title', description: '22222')

      expect(alert1).to eql(alert2)
      expect(alert1 == alert2).to be true
    end

    it "should work as a hash key" do
      alert1 = Forecast::Alert.new(title: 'matching title', description: '11111')
      alert2 = Forecast::Alert.new(title: 'matching title', description: '22222')

      h = {}
      h[alert1] = 1

      expect(h.include?(alert1)).to be true
      expect(h.include?(alert2)).to be true
      h[alert2] = 2
      expect(h[alert1]).to eql(2)
      expect(h[alert2]).to eql(2)

    end
  end
end



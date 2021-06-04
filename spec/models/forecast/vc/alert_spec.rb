require 'rails_helper'

RSpec.describe Forecast::Vc::Alert, type: :model do

  context Forecast::Vc::Alert do
    it "should show two alerts with same title as equal" do
      alert1 = Forecast::Vc::Alert.new(title: 'matching title', description: '11111')
      alert2 = Forecast::Vc::Alert.new(title: 'matching title', description: '22222')

      expect(alert1).to eql(alert2)
      expect(alert1 == alert2).to be true
    end

    it "should work as a hash key" do
      alert1 = Forecast::Vc::Alert.new(title: 'matching title', description: '11111')
      alert2 = Forecast::Vc::Alert.new(title: 'matching title', description: '22222')

      h = {}
      h[alert1] = 1

      expect(h.include?(alert1)).to be true
      expect(h.include?(alert2)).to be true
      h[alert2] = 2
      expect(h[alert1]).to eql(2)
      expect(h[alert2]).to eql(2)

    end

    context 'parse_description#' do
      it 'should parse description correctly - 1' do
        alerts_hsh = {
          'description' => '...HEAT ADVISORY REMAINS IN EFFECT UNTIL 8 PM PDT THIS EVENING...\n* WHAT...High temperatures generally in the 90s.\n* WHERE...Peck, Clarkston, Pomeroy, Brewster, Omak, Gifford,\nCashmere, Lapwai, Nespelem, Oroville, Okanogan, Culdesac, Chelan,\nLewiston, Bridgeport, Entiat, and Wenatchee.\n* WHEN...Until 8 PM PDT this evening.\n* IMPACTS...Unusual early season heat may cause heat illnesses to\noccur.'
        }

        alert = Forecast::Vc::Alert.new(alerts_hsh)

        details = alert.alert_details

        expect(details.what).to eql('High temperatures generally in the 90s.')
        expect(details.where).to eql('Peck, clarkston, pomeroy, brewster, omak, gifford, cashmere, lapwai, nespelem, oroville, okanogan, culdesac, chelan, lewiston, bridgeport, entiat, and wenatchee.')
        expect(details.time).to eql('Until 8 pm pdt this evening.')
        expect(details.impacts).to eql('Unusual early season heat may cause heat illnesses to occur.')

      end

      it 'should parse description correctly - 2' do
        alerts_hsh = {
          'description' => '...HEAT ADVISORY REMAINS IN EFFECT UNTIL 8 PM PDT THIS EVENING...\n* WHAT...High temperatures in the 90s.\n* WHERE...In Washington, Lower Columbia Basin, Yakima Valley and\nFoothills of the Blue Mountains. In Oregon, Foothills of the\nNorthern Blue Mountains and Lower Columbia Basin.\n* WHEN...Until 8 PM PDT this evening.\n* IMPACTS...Hot temperatures may cause heat illnesses to occur.'
        }

        alert = Forecast::Vc::Alert.new(alerts_hsh)
        details = alert.alert_details

        expect(details.what).to eql('High temperatures in the 90s.')
        expect(details.where).to eql('In washington, lower columbia basin, yakima valley and foothills of the blue mountains. in oregon, foothills of the northern blue mountains and lower columbia basin.')
        expect(details.time).to eql('Until 8 pm pdt this evening.')
        expect(details.impacts).to eql('Hot temperatures may cause heat illnesses to occur.')

       end

    end
  end

end



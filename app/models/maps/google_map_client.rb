require_dependency 'google_url_signer'
module Maps
class GoogleMapClient

  def initialize(forecasts)
    @forecasts = forecasts
  end

  def image_src
    return '' if @forecasts.blank?
    uri = BASE_URL.dup

    uri << URL_PARAMS.to_query

    @forecasts.each do |loc, f|
      # different markers per location
      # &markers=color:blue|label:S|62.107733,-145.541936
      m_text = "label:#{f.forecast_id}|#{loc.latitude},#{loc.longitude}"
      uri << '&' + {markers: m_text}.to_query
    end

    GoogleUrlSigner.sign uri, API_KEY
    uri
  end

  #######
  private
  #######
  # FIXME use different api keys for devo and prod
  BASE_URL = "https://maps.googleapis.com/maps/api/staticmap?"
  API_KEY = Rails.application.credentials.google_maps[:api_key]

  URL_PARAMS = {
    size: '600x300',
    maptype: 'terrain', # roadmap, satellite, hybrid, and terrain
    scale: 1,
  }

end
end

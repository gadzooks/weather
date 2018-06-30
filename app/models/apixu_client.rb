require 'apixu'

class ApixuClient
  def initialize
    @client = Apixu::Client.new KEY
  end

  def current(city)
    #@client.current city

    SAMPLE[city.to_s.downcase.to_sym] || SAMPLE[:paris]
  end

  KEY = 'cd6636ddeb8a4174b4b20333182404'

  SAMPLE = {
    paris: {"location":{"name":"Paris","region":"Ile-de-France","country":"France","lat":48.87,"lon":2.33,"tz_id":"Europe/Paris","localtime_epoch":1524624591,"localtime":"2018-04-25 4:49"},"current":{"last_updated_epoch":1524623171,"last_updated":"2018-04-25 04:26","temp_c":12.0,"temp_f":53.6,"is_day":0,"condition":{"text":"Clear","icon":"//cdn.apixu.com/weather/64x64/night/113.png","code":1000},"wind_mph":9.4,"wind_kph":15.1,"wind_degree":250,"wind_dir":"WSW","pressure_mb":1013.0,"pressure_in":30.4,"precip_mm":0.0,"precip_in":0.0,"humidity":82,"cloud":0,"feelslike_c":10.4,"feelslike_f":50.7,"vis_km":10.0,"vis_miles":6.0},"forecast":{"forecastday":[{"date":"2018-04-25","date_epoch":1524614400,"day":{"maxtemp_c":16.4,"maxtemp_f":61.5,"mintemp_c":8.7,"mintemp_f":47.7,"avgtemp_c":13.7,"avgtemp_f":56.7,"maxwind_mph":12.5,"maxwind_kph":20.2,"totalprecip_mm":0.7,"totalprecip_in":0.03,"avgvis_km":17.9,"avgvis_miles":11.0,"avghumidity":66.0,"condition":{"text":"Moderate rain at times","icon":"//cdn.apixu.com/weather/64x64/day/299.png","code":1186},"uv":4.2},"astro":{"sunrise":"06:41 AM","sunset":"08:57 PM","moonrise":"03:39 PM","moonset":"04:59 AM"}}]}} ,
    seattle: {"location":{"name":"Seattle","region":"Washington","country":"United States of America","lat":47.61,"lon":-122.33,"tz_id":"America/Los_Angeles","localtime_epoch":1524713388,"localtime":"2018-04-25 20:29"},"current":{"last_updated_epoch":1524712509,"last_updated":"2018-04-25 20:15","temp_c":18.3,"temp_f":64.9,"is_day":0,"condition":{"text":"Partly cloudy","icon":"//cdn.apixu.com/weather/64x64/night/116.png","code":1003},"wind_mph":0.0,"wind_kph":0.0,"wind_degree":348,"wind_dir":"NNW","pressure_mb":1017.0,"pressure_in":30.5,"precip_mm":0.0,"precip_in":0.0,"humidity":40,"cloud":50,"feelslike_c":18.3,"feelslike_f":64.9,"vis_km":16.0,"vis_miles":9.0},"forecast":{"forecastday":[{"date":"2018-04-25","date_epoch":1524614400,"day":{"maxtemp_c":20.2,"maxtemp_f":68.4,"mintemp_c":9.2,"mintemp_f":48.6,"avgtemp_c":14.3,"avgtemp_f":57.8,"maxwind_mph":9.4,"maxwind_kph":15.1,"totalprecip_mm":0.0,"totalprecip_in":0.0,"avgvis_km":19.8,"avgvis_miles":12.0,"avghumidity":63.0,"condition":{"text":"Partly cloudy","icon":"//cdn.apixu.com/weather/64x64/day/116.png","code":1003},"uv":5.9},"astro":{"sunrise":"06:02 AM","sunset":"08:13 PM","moonrise":"03:25 PM","moonset":"04:25 AM"}}]}}
  }


end

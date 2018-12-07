# Sunny side up 

# tl;dr (select code samples)
## tech stack
- Use HAML, SCSS, coffeescript (when required), Rspec & guard (for testing)
## views
- Use partials in Views to keep code clean : https://github.com/gadzooks/weather/blob/master/app/views/weather/index.html.haml
- Helpers to keep view code clean : https://github.com/gadzooks/weather/blob/master/app/helpers/weather_helper.rb

## Design pattern
- Skinny controller fat model : https://github.com/gadzooks/weather/blob/master/app/controllers/weather_controller.rb
- Use singleton pattern to keep track of latitude / longitudes : https://github.com/gadzooks/weather/blob/master/app/models/latitude_longitude.rb

## Security
- Store API secret key securely : https://github.com/gadzooks/weather/blob/master/app/models/dark_sky/client.rb

## Decoupling code
- Use separate parser class to keep API specific details decoupled from rest of code and make it easier to plug in a different weather API : 
https://github.com/gadzooks/weather/blob/master/app/models/forecast/parser.rb

## Use ENUMs where they make sense
- Use ENUMs for forecast types : https://github.com/gadzooks/weather/blob/master/app/models/forecast/type.rb

## Ruby metaprogramming
- Use ruby metaprogramming to create class methods on the fly : https://github.com/gadzooks/weather/blob/master/app/models/forecast/time_series_summary.rb
- More ruby metaprogramming to create instant variables and keep code DRY : https://github.com/gadzooks/weather/blob/master/app/models/forecast/data.rb
- Dynamically set instance variable values and keep code DRY : https://github.com/gadzooks/weather/blob/master/app/models/forecast/data.rb

## testing - use Rspec and guard 
https://github.com/gadzooks/weather/blob/master/spec/models/forecast/parser_spec.rb

# Problem statement : 
Where should I go hiking in the next week based on weather forecasts ?

# Solution : 
I decided to build this simple website to answer that question for me. The Pacific NorthWest has a lot of micro-climates which means different parts of WA may have different weather even though they are not that far apart (from a geographic standpoint). I was tired of googling my favorite destinations one by one each time I wanted to decide where I should go to next. Enter this project. 

# Screenshots :
## Weather forecast summary for all the regions selected : 
![Alt text](https://github.com/gadzooks/weather/blob/master/public/Weather-page-summary-table.png?raw=true "Weather forecast summary table")
## Detailed weather forecast for one location :
![Alt text](https://github.com/gadzooks/weather/blob/master/public/Weather-detailed.png?raw=true "Detailed forecasat for one location")

# Weather API setup (only needed to run against the real API).
1) Sign up for a new dev account (only to run in prod mode) https://darksky.net/dev/account 
2) Upgrade Rails credetials as per https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2
3) Profit ??

# How to run : 
1) Download this code.
2) on command line, run : rails server 
3) localhost:3000 for test data, localhost:3000/prod for real weather information.

# Tech details
* Stack - Rails 5.2, SCSS, haml, bootstrap, Rspec
* Weather API provided by DarkSky.net
* Weather icons : https://www.freepik.com/free-photos-vectors/icon

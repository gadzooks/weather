## tl;dr (select code samples)
### Tech stack
- Use HAML, SCSS, coffeescript (when required), Rspec & guard (for testing)
### Views
- haml > erb
- SASS > CSS
- Use partials in Views to keep code clean : https://github.com/gadzooks/weather/blob/master/app/views/weather/index.html.haml
- Helpers  : https://github.com/gadzooks/weather/blob/master/app/helpers/weather_helper.rb

### Design patterns
- Skinny controller fat model : https://github.com/gadzooks/weather/blob/master/app/controllers/weather_controller.rb
- Use singleton pattern to keep track of latitude / longitudes : https://github.com/gadzooks/weather/blob/master/app/models/latitude_longitude.rb
- Strong cohesion, loose coupling : Use separate parser class to keep API specific details decoupled from rest of code and make it easier to plug in a different weather API :
https://github.com/gadzooks/weather/blob/master/app/models/forecast/parser.rb
- Use ENUMs for forecast types : https://github.com/gadzooks/weather/blob/master/app/models/forecast/type.rb
- Make parallel service calls using Hydra : https://github.com/gadzooks/weather/blob/2e00d8eca2c64b65bd20b5ae59e4e8a99f9c1101/app/models/dark_sky/client.rb#L43

### Security
- Store API secret key securely : https://github.com/gadzooks/weather/blob/master/app/models/dark_sky/client.rb

### Ruby metaprogramming
- Create class methods on the fly : https://github.com/gadzooks/weather/blob/master/app/models/forecast/time_series_summary.rb
- Create instant variables dynamically (DRY) : https://github.com/gadzooks/weather/blob/master/app/models/forecast/data.rb
- Dynamically set instance variable values and keep code DRY : https://github.com/gadzooks/weather/blob/master/app/models/forecast/data.rb

### Testing - use Rspec and guard
- RSpec for critical parsing code
https://github.com/gadzooks/weather/blob/master/spec/models/forecast/parser_spec.rb
- Added acceptance tests using turnip (cucumber alernative) 
https://github.com/gadzooks/weather/blob/2e00d8eca2c64b65bd20b5ae59e4e8a99f9c1101/spec/acceptance/weather_page.feature#L1

### Custom rake tasks
- Rake task to run rails server in production locally 
https://github.com/gadzooks/weather/blob/3e37ff24c0e89b1e6aa6498edef836d6c63ac161/lib/tasks/runlocally.rake#L1

## Problem statement :
Where should I go hiking in the next week based on weather forecasts ?

### Solution :
I decided to build this simple website to answer that question for me. The Pacific NorthWest has a lot of micro-climates which means different parts of WA may have different weather even though they are not that far apart (from a geographic standpoint). I was tired of googling my favorite destinations one by one each time I wanted to decide where I should go to next. Enter this project.

### Screenshots :
#### Weather forecast summary for all the regions selected :
![Alt text](https://github.com/gadzooks/weather/blob/master/public/Weather-page-summary-table.png?raw=true "Weather forecast summary table")
#### Detailed weather forecast for one location :
![Alt text](https://github.com/gadzooks/weather/blob/master/public/Weather-detailed.png?raw=true "Detailed forecasat for one location")

### Weather API setup (only needed to run against the real API).
1) Sign up for a new dev account (only to run in prod mode) https://darksky.net/dev/account
2) Upgrade Rails credetials as per https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2
3) Profit ??

### Caching
1) Typheus is setup to use Rails default cache
2) To enable caching/disable in development : rails dev:cache

### How to run :
1) Download this code.
2) on command line, run : rails server
3) localhost:3000/test for test data, localhost:3000 for real weather information.

### Testing :
bundle exec rspec
bundle exec guard

### Tech details
* Stack - Rails 6.0, SCSS, haml, bootstrap, Rspec
* Weather API provided by VisualCrossing.com, DarkSKY
* Weather icons : http://erikflowers.github.io/weather-icons

### Installation
```sh
# Install rails 6.0.0 : 
gem install rails -v 6.0.0
# Create credentials : 
rails credentials:edit
# Install postgres : 
brew install postgres
# Create postgres user : 
~/homebrew/bin/createuser -s postgres
# Log in and create weather_dev db : 
createdb weather_dev

postgres=# create database weather_dev;
CREATE DATABASE
postgres=# \l
                               List of databases
    Name     |   Owner   | Encoding | Collate | Ctype |    Access privileges
-------------+-----------+----------+---------+-------+-------------------------
 postgres    | akarwande | UTF8     | C       | C     |
 template0   | akarwande | UTF8     | C       | C     | =c/akarwande           +
             |           |          |         |       | akarwande=CTc/akarwande
 template1   | akarwande | UTF8     | C       | C     | =c/akarwande           +
             |           |          |         |       | akarwande=CTc/akarwande
 weather_dev | postgres  | UTF8     | C       | C     |
(4 rows)
```

## Devise
http://railsapps.github.io/tutorial-rails-mongoid-devise.html

## MAWS (move to aws)
1. Move ahoy to mongo : https://github.com/andrewculver/ahoy#mongodb
2. move devise to mongo : http://railsapps.github.io/tutorial-rails-mongoid-devise.html
3. setup website on AWS using Elastic Beanstalk
4. set up CICD with CodePipeline
5. update travelweather.co to new website.

## Deployment to heroku
Based on Procfile at root.

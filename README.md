# Problem statement : 
Where should I go hiking in the next week based on weather forecasts ?

# Solution : 
I decided to build this simple website to answer that question for me. The Pacific NorthWest has a lot of micro-climates which means different parts of WA may have different weather even though they are not that far apart (from a geographic standpoint). I was tired of googling my favorite destinations one by one each time I wanted to decide where I should go to next. Enter this project. 

## Weather API setup (only needed to run against the real API).
1) Sign up for a new dev account (only to run in prod mode) https://darksky.net/dev/account 
2) Upgrade Rails credetials as per https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2
3) Profit ??

# How to run : 
1) Download this code.
2) on command line, run : rails server 
3) localhost:3000 for test data, localhost:3000/prod for real weather information.

# Tech details
Stack - Rails 5.2, SCSS, haml, bootstrap, Rspec
Weather API provided by DarkSky.net
Weather icons : https://www.freepik.com/free-photos-vectors/icon

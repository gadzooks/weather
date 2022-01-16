# Guides to upgrade : 

https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-6-1-to-rails-7-0

## Upgrade Ruby
- Use rben as the ruby version manager
- rbenv install 2.6.9
- rbenv global 2.6.9
- rbenv rehash
- ruby -v (will show 1.6.9)
- update ruby in Gemfile and then run `bundle update`
-

* Upgrade Ruby first and then upgrade Rails
* Upgrade to 1 minor version at a time and then run `bundle update` and run all
  tests and continue to next ruby version

All ruby versions : https://www.ruby-lang.org/en/downloads/releases/

All rails versions : https://rubygems.org/gems/rails/versions

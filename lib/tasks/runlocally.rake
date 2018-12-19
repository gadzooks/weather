namespace :runlocally do
  desc "run rails server in production mode locall"
  task production_mode: ['assets:clobber', 'assets:precompile'] do
    # from https://github.com/heroku/rails_12factor
    ENV['RAILS_SERVE_STATIC_FILES'] = 'true'
    ENV['RAILS_LOG_TO_STDOUT'] = 'true'
    Process.exec("rails s -e production")
  end

end

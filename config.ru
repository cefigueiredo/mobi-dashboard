require 'sinatra/activerecord'
require './models/account'
require './models/account_check'
require 'dashing'

set :environment, ENV['RACK_ENV'] || 'development'

set :database_file, 'config/database.yml'

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application

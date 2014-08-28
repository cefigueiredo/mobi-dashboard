require 'sinatra/activerecord'
require './models/account'
require './models/account_check'
require 'dashing'

configure :production, :development do
  set :environment, 'development'
  set :database_file, 'config/database.yml'

  ActiveRecord::Base.connection
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application

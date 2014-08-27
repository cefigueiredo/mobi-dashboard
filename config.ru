require 'dashing'
require 'sinatra/activerecord'

configure :production, :development do
  set :environment, ENV['RACK_ENV']
  set :database, 'mysql://vagrant:vagrant@localhost:3306/dashboard_newrelic'

  ActiveRecord::Base.estabilish_connection(:database)
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    set :database_file, 'config/database.yml'
    ActiveRecord::Base.connection
  end
end

# Require sinatra, as well as out object model
require 'sinatra'
require 'active_record'
require'./models/simple_object'

# Set database config
db_configuration = YAML.load(File.read('./db/config.yml'))
environment = ENV.fetch('RACK_ENV') { 'development' }
ActiveRecord::Base.establish_connection(db_configuration[environment])
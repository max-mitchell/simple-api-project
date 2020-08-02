# Require sinatra, as well as out object model
require 'sinatra'
require 'active_record'
require'./models/simple_object'

# Set database config
db_configuration = YAML.load(File.read('./db/config.yml'))
ActiveRecord::Base.establish_connection(db_configuration["development"])
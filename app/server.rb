# server.rb
# Control for the api.
# Provides ability to create, edit, fetch, and destroy
# simple json objects

# Require sinatra, as well as out object model
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require '.SimpleObject'

# Set database config
set :database, {adapter: 'postgresql', database: 'development'}
mime_type :json, 'application/json'

# config.ru
# Configuration for running the server with puma

require './config/environment'
require 'sinatra'
require 'active_record'
require 'puma'

# Require api class
require './app/simple_object_api'

# Use ConnectionManagement to ensure connections are closed eventually
# use ActiveRecord::ConnectionAdapters::ConnectionManagement

# Run the api
run SimpleObjectApi
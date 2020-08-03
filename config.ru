# config.ru
# Configuration for running the server with puma

require './config/environment'
require 'sinatra'
require 'active_record'
require 'puma'

# Require api class and helpers
require './helpers/application_helpers'
require './app/simple_object_api'

# Use ConnectionManagement to ensure connections are closed eventually
# use ActiveRecord::ConnectionAdapters::ConnectionManagement

# Run the api
run SimpleObjectApi
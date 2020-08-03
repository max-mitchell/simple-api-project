# config.ru
# Configuration for running the server with puma

require 'sinatra'
require 'active_record'
require 'puma'

require './config/environment'

# Require api class and helpers
require './helpers/application_helpers'
require './app/simple_object_api'

# Run the api
run SimpleObjectApi
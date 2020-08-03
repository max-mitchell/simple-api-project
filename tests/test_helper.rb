# tests/test_helper.rb
# Helper for all tests

# Set test env
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'database_cleaner/active_record'
require 'rack/test'
require 'sinatra/base'

require './config/environment'

require './helpers/application_helpers'
require './app/simple_object_api'

# Used to clean db between tests
DatabaseCleaner.clean_with :deletion
DatabaseCleaner.strategy = :transaction
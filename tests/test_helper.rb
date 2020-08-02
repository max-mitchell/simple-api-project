# tests/test_helper.rb
# Helper for all tests

require 'minitest/autorun'
require 'database_cleaner/active_record'
require './config/environment'

# Used to clean db between tests
DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

class Minitest::Unit::TestCase
    def setup
        super
        DatabaseCleaner.start
      end
    
      def teardown
        super
        DatabaseCleaner.clean
      end
  end
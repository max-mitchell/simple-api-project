# tests/server_test.rb
require './tests/test_helper'
require 'rack/test'
require 'sinatra/base'
require './app/server'

class ServerTest < MiniTest::Unit::TestCase
    include Rack::Test::Methods

    def app
        SimpleObjectApi
    end

    def test_create
        body = {
            'fname' => "Joe",
            'lname' => "Smith",
            'dob' => "24 April 2020"
        }
        post '/api/object', body.to_json, "CONTENT_TYPE" => "application/json"
        assert last_response.ok?
    end
end
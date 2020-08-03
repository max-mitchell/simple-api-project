# tests/server_test.rb
#
# Feature tests for the various routes.
# Checks for valid requests, invalid requests, and 
# database consistency

require './tests/test_helper'

include Rack::Test::Methods

def app
    @app ||= SimpleObjectApi
end

def parse_json(data)
    begin
        JSON.parse(data)
    rescue
        false
    end
end

describe SimpleObjectApi do

    describe "When fetching an existing object" do
        DatabaseCleaner.start

        body = {
            'fname' => "Joe",
            'lname' => "Smith",
            'dob' => "24 April 2020"
        }
        sObj = SimpleObject.create(data: body.to_json)

        resp = get '/api/objects/' + sObj.id

        it "must respond with 200" do
            assert resp.ok?
        end
        
        json_data = parse_json resp.body

        it "must have a valid json body" do
            assert json_data
        end

        it "must respond with the correct uid" do
            assert_equal sObj.id, json_data["uid"]
        end

        it "must respond with matching json data" do
            assert_equal body.to_json, json_data["json-data"]
        end

        DatabaseCleaner.clean
    end

    describe "When creating a new object" do
        DatabaseCleaner.start
        body = {
            'fname' => "Joe",
            'lname' => "Smith",
            'dob' => "24 April 2020"
        }
        resp = post '/api/objects', body.to_json

        it "must respond with 200" do
            assert resp.ok?
        end
        
        json_data = parse_json resp.body
        puts json_data

        it "must have a valid json body" do
            assert json_data
        end

        it "must respond with a new uid" do
            assert json_data["uid"]
        end

        it "must respond with matching json data" do
            assert_equal body.to_json, json_data["json-data"]
        end
        DatabaseCleaner.clean
    end

end

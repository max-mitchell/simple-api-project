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

    describe "When fetching all existing objects" do
        DatabaseCleaner.start

        50.times { SimpleObject.create().id }

        resp = get '/api/objects'

        object_ids = []
        SimpleObject.all.each do |obj|
            object_ids << obj.id
        end

        it "must respond with 200" do
            assert resp.ok?
        end
        
        it "must have a valid json body" do
            assert resp.body
        end

        json_data = parse_json resp.body

        it "must respond with the correct number of uids" do
            assert_equal json_data.length(), object_ids.length()
        end


        it "must respond with the correct uids" do
            object_ids.each_with_index do |uid, index|
                assert json_data[index]["url"].include? uid
            end
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
        first_resp = post '/api/objects', body.to_json

        it "must respond with 200" do
            assert first_resp.ok?
        end
        
        first_json_data = parse_json first_resp.body

        it "must have a valid json body" do
            assert first_json_data
        end

        it "must respond with a new uid" do
            assert first_json_data["uid"]
        end

        it "must respond with matching json data" do
            assert_equal body, first_json_data["json-data"]
        end

        second_resp = post '/api/objects', body.to_json
        second_json_data = parse_json second_resp.body

        it "must respond with a different uid for a new object with the same data" do
            assert second_json_data["uid"] != first_json_data["uid"]
        end
        DatabaseCleaner.clean
    end

end
# tests/server_test.rb
#
# Feature tests for the various routes.
# Checks for valid requests, invalid requests, and 
# database consistency

require './tests/test_helper'

include Rack::Test::Methods

def app
    # Our simple api
    @app ||= SimpleObjectApi
end

# Small function to parse response bodies
def parse_json(data)
    begin
        JSON.parse(data)
    rescue
        false
    end
end

# Helper for basic response assertions
def test_resp(resp, data)
    it "must respond with 200" do
        assert resp.ok?
    end
    
    it "must have a valid json body" do
        assert data
    end
end

# Helper for testing error messages
def test_error(resp, verb, url, msg)
    it "must not respond with 200" do
        assert !resp.ok?
    end

    data = parse_json resp.body

    it "must have a valid json body" do
        assert data
    end

    it "must have valid error details" do
        assert_equal verb, data["verb"]
        assert data["url"].include? url
        assert_equal msg, data["error"]
    end 
end

describe SimpleObjectApi do

    # GET
    # Fetches an existing object and ensures the 
    # data is accurate. Also attempts to fetch an
    # object that does not exist and looks for the
    # proper error.
    describe "When fetching an existing object" do
        DatabaseCleaner.start

        # Create a new simple object
        body = {
            'fname' => "Joe",
            'lname' => "Smith",
            'dob' => "24 April 2020"
        }
        sObj = SimpleObject.create(data: body.to_json)

        # Fetch that object
        good_resp = get '/api/objects/' + sObj.id
        good_json_data = parse_json good_resp.body

        # Run tests on the response
        test_resp good_resp, good_json_data

        it "must respond with the correct uid" do
            assert_equal sObj.id, good_json_data["uid"]
        end

        it "must respond with matching json data" do
            assert_equal body.to_json, good_json_data["json-data"]
        end

        # Attempt to fetch an object that does not exist
        bad_resp = get '/api/objects/1234'

        # Run tests on the bad response
        test_error bad_resp, "GET", '/api/objects/1234', SimpleObjectApi::MISSING_UID_ERROR

        DatabaseCleaner.clean
    end

    # GET all
    # Fetches all objects from the api and ensures 
    # the correct uids have been fetched. Also fetches
    # all when no objects are in the DB and looks for
    # a valid error
    describe "When fetching all existing objects" do
        DatabaseCleaner.start

        # First, fetch all when the DB is empty
        bad_resp = get '/api/objects'

        # Run tests on the bad response
        test_error bad_resp, "GET", '/api/objects', SimpleObjectApi::EMPTY_DB_ERROR

        # Then, fill the DB and check again
        50.times { SimpleObject.create().id }

        good_resp = get '/api/objects'
        good_json_data = parse_json good_resp.body

        # Run tests on the response
        test_resp good_resp, good_json_data

        # Fill a list of current uids
        object_ids = []
        SimpleObject.all.each do |obj|
            object_ids << obj.id
        end

        # Check real uids against fetched uids
        it "must respond with the correct number of uids" do
            assert_equal good_json_data.length(), object_ids.length()
        end

        it "must respond with the correct uids" do
            object_ids.each_with_index do |uid, index|
                assert good_json_data[index]["url"].include? uid
            end
        end

        DatabaseCleaner.clean
    end

    # POST
    # Ensures that when an object is created, the json data
    # is returned with a uid but not with create/modify columns.
    # Make sure that two identical objects are given different
    # uids. Also ensure that empty or poorly formatted json 
    # data is met with an error message.
    describe "When creating a new object" do
        DatabaseCleaner.start
        
        # Create a json body an send it to the api
        body = {
            'fname' => "Joe",
            'lname' => "Smith",
            'dob' => "24 April 2020"
        }
        first_resp = post '/api/objects', body.to_json
        first_json_data = parse_json first_resp.body

        # Run tests on the response
        test_resp first_resp, first_json_data

        it "must respond with a new uid" do
            assert first_json_data["uid"]
        end

        it "must respond with matching json data" do
            assert_equal body, first_json_data["json-data"]
        end

        # Send the same body again and look for a different uid
        second_resp = post '/api/objects', body.to_json
        second_json_data = parse_json second_resp.body

        it "must respond with a different uid for a new object with the same data" do
            assert second_json_data["uid"] != first_json_data["uid"]
        end

        # Send an empty body and look for a valid error message
        empty_resp = post '/api/objects'

        # Run tests on the bad response
        test_error empty_resp, "POST", '/api/objects', SimpleObjectApi::JSON_DATA_ERROR

        # Send a poorly formatted body and look for a valid error message
        malformed_resp = post '/api/objects', '{"so_bad" "it\'s sad"}'

        # Run tests on the bad response
        test_error malformed_resp, "POST", '/api/objects', SimpleObjectApi::JSON_DATA_ERROR

        DatabaseCleaner.clean
    end

    # PUT
    # Ensures that when an object is updated, its json data
    # is fully replaced, but the same uid is returned. Also
    # make sure that when poorly formatted or empty json data
    # is submitted, or when an invalid uid is sent, an error
    # is returned.
    describe "When updating an existing object" do
        DatabaseCleaner.start
        
         # Create a new simple object
         body = {
            'fname' => "Joe",
            'lname' => "Smith",
            'dob' => "24 April 2020"
        }
        sObj = SimpleObject.create(data: body.to_json)

        # Create a body to replace the data with
        replace = {
            "something" => "else"
        }

        # Update the object
        first_resp = put '/api/objects/' + sObj.id, replace.to_json
        first_json_data = parse_json first_resp.body

        # Run tests on the response
        test_resp first_resp, first_json_data

        it "must respond with the same uid" do
            assert_equal sObj.id, first_json_data["uid"]
        end

        it "must respond with correct json data" do
            assert_equal replace, first_json_data["json-data"]
        end

        # Send the put again and expect the same results
        second_resp = put '/api/objects/' + sObj.id, replace.to_json
        second_json_data = parse_json second_resp.body

        # Run tests on the second response
        test_resp second_resp, second_json_data

        it "must respond with the same uid" do
            assert_equal sObj.id, second_json_data["uid"]
        end

        it "must respond with correct json data" do
            assert_equal replace, second_json_data["json-data"]
        end

        # Send an empty body and look for a valid error message
        empty_resp = put '/api/objects/' + sObj.id

        # Run tests on the bad response
        test_error empty_resp, "PUT", '/api/objects', SimpleObjectApi::JSON_DATA_ERROR

        # Send a poorly formatted body and look for a valid error message
        malformed_resp = put '/api/objects/' + sObj.id, '{"so_bad" "it\'s sad"}'

        # Run tests on the bad response
        test_error malformed_resp, "PUT", '/api/objects', SimpleObjectApi::JSON_DATA_ERROR

        # Send a bad uid and look for a valid error message
        missing_resp = put '/api/objects/1234', '{"so_bad" "it\'s sad"}'

        # Run tests on the bad response
        test_error missing_resp, "PUT", '/api/objects', SimpleObjectApi::MISSING_UID_ERROR

        DatabaseCleaner.clean
    end

    # DELETE
    # Deletes a simple object and ensures it's really
    # gone. Deletes non-existent objects and makes sure
    # nothing is returned.
    describe "When fetching an existing object" do
        DatabaseCleaner.start

        # Create a new simple object
        body = {
            'fname' => "Joe",
            'lname' => "Smith",
            'dob' => "24 April 2020"
        }
        sObj = SimpleObject.create(data: body.to_json)

        # Delete that object
        first_resp = delete '/api/objects/' + sObj.id

        # Run tests on the response
        it "must respond with 200" do
            assert first_resp.ok?
        end
        
        it "must have an empty body" do
            assert !first_resp.body.present?
        end

        # Delete the object again
        second_resp = delete '/api/objects/' + sObj.id

        # Run tests on the response
        it "must respond with 200" do
            assert second_resp.ok?
        end
        
        it "must have an empty body" do
            assert !second_resp.body.present?
        end

        DatabaseCleaner.clean
    end

end
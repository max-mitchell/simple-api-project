# tests/server_test.rb
require './tests/test_helper'

include Rack::Test::Methods

def app
    SimpleObjectApi
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

        resp = get '/api/object/' + sObj.id
        puts resp.inspect
        it "must respond with 200" do
            assert last_response.ok?
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
        post '/api/object', body.to_json, "CONTENT_TYPE" => "application/json"
        it "must respond with 200" do
            assert last_response.ok?
        end
        DatabaseCleaner.clean
    end

end

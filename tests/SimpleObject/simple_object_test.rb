# tests/SimpleObject/simple_object_test.rb
#
# Unit tests for the SimpleObject model, as
# well as for various class methods

require './tests/test_helper'

class SimpleObjectTest < MiniTest::Test
    # Make sure to clean the DB after every run
    def setup
        DatabaseCleaner.start
        @app = SimpleObjectApi.new
    end

    def teardown
        DatabaseCleaner.clean
    end

    # Tests basic DB operations
    def test_db
        object = SimpleObject.new(data: {"hello": "world"})

        assert_equal object.data["hello"], "world"
        assert object.save
        assert_equal 1, SimpleObject.count

        object.destroy
        assert_equal 0, SimpleObject.count
    end

    # Test the send_json method
    def test_send_json
        data = {
            "hello" => "world"
        }
        assert_equal JSON.pretty_generate(JSON.load(data.to_json)), @app.helpers.send_json(data)
    end
end
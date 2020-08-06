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

    # Small function to parse response bodies
    def parse_json(data)
        begin
            JSON.parse(data)
        rescue
            false
        end
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
        data = { "hello" => "world" }
        assert_equal JSON.pretty_generate(JSON.load(data.to_json)), @app.helpers.send_json(data)

        empty = @app.helpers.send_json("")
        assert_equal empty, "[]"
    end

    # Test the send simple object method
    def test_send_simple_object
        object = SimpleObject.create(data: {"hello": "world"})
        data = @app.helpers.send_simple_object(object)
        assert data

        parsed = parse_json data
        assert_equal object.id, parsed["uid"]
        parsed.delete('uid')
        assert_equal object.data, parsed
    end
end
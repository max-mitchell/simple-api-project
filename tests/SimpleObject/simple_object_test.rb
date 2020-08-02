# tests/SimpleObject/simple_object_test.rb
require_relative '../test_helper'

class SimpleObjectTest < MiniTest::Unit::TestCase

    def setup
        @json_requests = [
            {
                firstName: "Max",
                lastName: "Mitchell",
                dob: "25 June 1903"
            },
            {
                firstName: "Jane",
                lastName: "Fonda",
                dob: "7 April 1848"
            },
            {
                firstName: "Mr",
                lastName: "Man",
                dob: "1 March 205"
            }
        ]
    end

    def test_create
        simple_object = SimpleObject.create(data: @json_requests[0])
        assert_equal JSON.parse(@json_requests[0]), simple_object.data
    end
end
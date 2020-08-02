# tests/SimpleObject/simple_object_test.rb
require_relative '../test_helper'

class SimpleObjectTest < MiniTest::Unit::TestCase
    def test_create
        simple_object = SimpleObject.create(data: {message: "hello world"})
        assert_equal 'hello world', simple_object.data["message"]
    end
end
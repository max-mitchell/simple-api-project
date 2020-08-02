# tests/SimpleObject/simple_object_test.rb
require_relative '../test_helper'

class SimpleObjectTest < MiniTest::Unit::TestCase
    def test_create
        object = SimpleObject.create(data: {"hello": "world"})
        assert_equal object.data["hello"], "world"
        assert_equal 1, SimpleObject.count
    end

    def test_delete
        object = SimpleObject.create()
        assert_equal 1, SimpleObject.count
        uid = object.id
        SimpleObject.where(id: uid).destroy_all
        assert_equal 0, SimpleObject.count
    end

    def test_edit
        object = SimpleObject.create(data: {"hello": "world"})
        assert_equal object.data["hello"], "world"
        object.update(data: {"hello": "goodbye"})
        assert_equal object.data["hello"], "goodbye"
        assert_equal 1, SimpleObject.count
    end

    def test_get
        object = SimpleObject.create(data: {"hello": "world"})
        id = object.id
        data = object.data
        object2 = SimpleObject.where(id: id).first
        assert_equal data["hello"], object2.data["hello"]
    end
end
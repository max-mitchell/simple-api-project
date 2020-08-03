# simple_object.rb
# Our simple object model for storing
# json data. Uses uuids as primary key

# ---
# id: primary key, uuid
# data: json data
# created_at: datetime
# updated_at: datetime
# ---
require 'active_record'

class SimpleObject < ActiveRecord::Base
    # Sort by date created instead of uuid primary key
    self.implicit_order_column = :created_at
end
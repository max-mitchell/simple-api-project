# models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    # Sort by date created instead of uuid primary key
    self.implicit_order_column = :created_at
  end
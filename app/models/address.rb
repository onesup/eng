class Address < ActiveRecord::Base
  self.connection
  self.primary_key = "zip"
end

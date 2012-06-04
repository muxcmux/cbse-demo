require 'rubygems'
require 'uuidtools'
module UUIDHelper
  
  def generate_random_number
    UUIDTools::UUID.timestamp_create.to_s
  end
  
end
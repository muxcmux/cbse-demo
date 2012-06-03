class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :balance, :name, :number
end

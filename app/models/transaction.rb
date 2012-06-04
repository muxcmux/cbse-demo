class Transaction < ActiveRecord::Base
  belongs_to :account
  attr_accessible :amount, :type
end

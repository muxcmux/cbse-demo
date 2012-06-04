require 'uuid_helper'
class Account < ActiveRecord::Base
  
  include UUIDHelper
  
  belongs_to :user
  has_many :transactions, dependent: :destroy
  
  attr_accessible :balance, :name, :number, :pin, :user_id
  
  
  
  before_validation :set_acc_number
  
  validates :name, presence: true
  validates :number, presence: true
  validates :pin, presence: true
  validates :user_id, presence: true
  
  def set_acc_number
    self.number = generate_random_number if self.number.blank?
  end
  
end

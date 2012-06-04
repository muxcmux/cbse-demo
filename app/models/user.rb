class User < ActiveRecord::Base
  has_many :accounts, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :telephone, :password, :password_confirmation, :remember_me, :firstname, :lastname, :city, :country, :address
  
  # attr_accessible :title, :body
  
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :address, presence: true
end

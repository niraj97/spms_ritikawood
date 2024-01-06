class User < ApplicationRecord
  has_many :customers
  
  has_secure_password
  validates :email, uniqueness: true
end

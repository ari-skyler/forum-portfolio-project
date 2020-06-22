class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: true
  has_many :posts
end

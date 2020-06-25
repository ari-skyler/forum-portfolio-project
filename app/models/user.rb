class User < ActiveRecord::Base
  include DataFormatting
  has_secure_password
  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: true
  has_many :posts
  has_many :comments
  def delta=(delta)
    self.bio=(undelta(delta))
  end
  def pre_username=(string)
    self.username=(string.downcase)
  end
end

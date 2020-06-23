class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true
end

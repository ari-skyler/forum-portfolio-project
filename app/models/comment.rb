class Comment < ActiveRecord::Base
  include DataFormatting
  belongs_to :user
  belongs_to :post
  validates :content, presence: true
  def delta=(delta)
    self.content=(undelta(delta))
  end
end

class Post < ActiveRecord::Base
  include DataFormatting
  belongs_to :user
  has_many :comments
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true
  def delta=(delta)
    self.content=(undelta(delta))
  end
    def raw_title=(title)
      slug = title.downcase.gsub(" ", "-")
      i = 1
      t = true
      while t
        if i == 2
          slug = slug + "-" + i.to_s
        elsif i > 2
          arr = slug.split("-")
          num = arr[-1].to_i
          num+=1
          arr[-1] = num.to_s
          slug = arr.join("-")
        end
        post = Post.find_by(slug: slug)
        if !post
          t = false
        end
        i+=1
      end
      self.slug=(slug)
      self.title=(title)
    end
    def update(params)
      params.delete("_method")
      self.delta = params[:delta]
      self.raw_title = params[:raw_title]
      self.save
    end
end

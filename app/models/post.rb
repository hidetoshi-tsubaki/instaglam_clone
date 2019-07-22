class Post < ApplicationRecord
  mount_uploader :img, ImgUploader
  belongs_to :user
  has_many :comments
  has_many :bookmarks, foreign_key: "bookmarked_post_id", dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :notifications, dependent: :destroy
  validates :user_id ,presence: true
  validates :img ,presence: true
  validates :title ,{presence: true, length: {maximum: 256}}

  def self.search(keywords_params)
    return posts = Post.all.recent if keywords_params == ""
    keywords = keywords_params.split(/[[:blank:]]+/)
    posts = []
    keywords.each do |keyword|
      next if keyword == ""
      posts += Post.where('title LIKE ? ',"%#{keyword}%")
    end
    # uniq!だと、変更がないとnilを返してしまう
    posts = posts.uniq
  end
end

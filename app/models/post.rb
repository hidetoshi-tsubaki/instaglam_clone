class Post < ApplicationRecord
  mount_uploader :img, ImgUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, foreign_key: "bookmarked_post_id", dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :notifications, dependent: :destroy
  validates :user_id ,presence: true
  validates :img ,presence: true
  validates :title ,{presence: true, length: {maximum: 256}}

  def self.search(keywords_params,current_page_params,user_id,user)
    # return posts = Post.all.recent if keywords_params == ""
      return posts = Post.get_all_posts(current_page_params,user_id,user) if keywords_params == ""
    keywords = keywords_params.split(/[[:blank:]]+/)
    posts = []
    keywords.each do |keyword|
      next if keyword == ""
      # posts += Post.where('title LIKE ? ',"%#{keyword}%")
      posts += Post.get_searched_result(keywords_params,current_page_params,user_id,user)
    end
    # uniq!だと、変更がない場合、nilを返してしまう
    posts = posts.uniq
  end

   def self.get_searched_result(keyword,current_page,user_id,user)
    case current_page
    when 'all_posts' then
      where('title LIKE ? ',"%#{keyword}%")
    when 'feed' then
      where("(user_id IN ?) AND (title LIKE ?)",current_user.following_ids,"%#{keyword}%")
    when 'show'
      where("(user_id = ?) AND (title LIKE ?)", user_id.to_i,"%#{keyword}%")
    end
  end

  def self.get_all_posts(current_page,user_id,user)
    case current_page
    when 'all_posts' then
      Post.all.recent 
    when 'feed' then
      Post.where("user_id IN (?)",user.following_ids).recent 
    when 'show'
      Post.where(user_id: user_id.to_i).recent
    end
  end
  
end

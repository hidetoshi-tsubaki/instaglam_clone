class User < ApplicationRecord
  mount_uploader :img, ImgUploader
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, foreign_key: "user_id", dependent: :destroy
  has_many :bookmarked_posts, through: :bookmarks
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships
  has_many :active_notifications, foreign_key: "sender_id", class_name: "Notification", dependent: :destroy
  has_many :passive_notifications, foreign_key: "reciever_id", class_name: "Notification", dependent: :destroy
  validates :name, { presence: true, length: {maximum: 40}}
  validates :username, { presence: true,uniqueness: true, length: {maximum: 40}}
  validates :introduction, length: {maximum: 256}
  # VALID_URL_REGEX = "/\Ahttp(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w-.\/?%&=]*)?/"
  # validates :website ,{length: {maximum: 256 }, format: {with: VALID_URL_REGEX ,allow_blank: true }}
  # VALID_TEL_REGEX = "/\A\d{10,11}\z/"
  # validates :tel ,format: {with: VALID_TEL_REGEX, allow_blank: true }
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable,omniauth_providers: [:facebook],
         :authentication_keys => [:username]

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value", { :value => username }]).first
    else
      where(conditions).first
    end
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end
    else
      super
    end
  end

  def already_bookmarked?(post)
    bookmarks.find_by(bookmarked_post_id: post.id)
  end

  def bookmark(post)
    bookmarks.create!(bookmarked_post_id: post.id)
  end

  def remove_bookmark(post)
    bookmarks.find_by(bookmarked_post_id: post.id).destroy
  end

  def already_followed?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end
end

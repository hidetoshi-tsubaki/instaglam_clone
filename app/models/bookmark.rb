class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarked_post, class_name: "Post"
end

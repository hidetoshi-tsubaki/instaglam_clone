class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
end

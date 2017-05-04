class UserConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :user_1, class_name: :User
  belongs_to :user_2, class_name: :User
end

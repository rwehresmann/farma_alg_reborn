class UserConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :user_1, class_name: :User
  belongs_to :user_2, class_name: :User

  def self.similarity(user_1, user_2)
    where(user_1: user_1, user_2: user_2)
    .or(where(user_1: user_2, user_2: user_1)).pluck(:similarity).first
  end
end

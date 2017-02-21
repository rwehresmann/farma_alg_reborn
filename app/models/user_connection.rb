class UserConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :user_1, class_name: :User
  belongs_to :user_2, class_name: :User

  scope :similarity, -> (user_1, user_2) do
    where(user_1: user_1, user_2: user_2).or(where(user_1: user_2, user_2: user_1)).pluck(:similarity).first
  end

  # user_1 similarity to user_2 means the same similarity of user_2
  # to user_1.
  def self.create_simetrical_record(user_1, user_2, similarity)
    create!(user_1: user_1, user_2: user_2, similarity: similarity)
    create!(user_1: user_2, user_2: user_1, similarity: similarity)
  end
end

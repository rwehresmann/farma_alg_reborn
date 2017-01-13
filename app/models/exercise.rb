class Exercise < ApplicationRecord
  validates_presence_of :title, :description

  belongs_to :user
  has_many :questions
  has_and_belongs_to_many :teams

  # Return user progress according the number of questions answered correctly.
  def user_progress(user)
    progress_per_question = 100.fdiv(questions.count)
    total_progress = 0

    questions.each do |question|
      total_progress += progress_per_question if user.answered_correctly?(question)
    end
    total_progress
  end
end

class Exercise < ApplicationRecord
  validates_presence_of :title, :description

  belongs_to :user
  has_many :questions, dependent: :destroy
  has_and_belongs_to_many :teams

  # Return user progress according the number of questions answered correctly.
  def user_progress(user, team)
    progress_per_question = 100.fdiv(questions.count)
    total_progress = 0

    questions.each do |question|
      answered_correctly = question.answered_by_user?(
        user, team: team, only_correct: true)
      total_progress += progress_per_question if answered_correctly
    end

    total_progress
  end
end

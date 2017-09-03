class TeamExercise < ApplicationRecord
  validates_inclusion_of :active, in: [true, false]

  belongs_to :team
  belongs_to :exercise
end

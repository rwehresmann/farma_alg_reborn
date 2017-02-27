require 'utils/incentive_ranking'

class User < ApplicationRecord
  include IncentiveRanking

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates_inclusion_of :teacher, in: [true, false]
  validates_inclusion_of :admin, in: [true, false]

  has_many :exercises
  has_many :answers
  has_many :teams_created, class_name: 'Team', foreign_key: "owner_id"
  has_and_belongs_to_many :teams

  # If the user is a teacher, return the teams created by him, else return
  # the teams where he is enrolled.
  def my_teams
    return self.teams_created if teacher?
    teams
  end

  # Check if the question is unanswered.
  def unanswered?(question)
    answers.where(question: question).empty?
  end

  # Check if the question is already correctly answered.
  def answered_correctly?(question)
    !answers.where(question: question, correct: true).empty?
  end

  # Return the questions answered by the user to a specific team.
  def team_questions_answered(team)
    answers.where(team: team).map(&:question).uniq
  end

  def incentive_ranking(team, limits = {})
    IncentiveRanking.build(self, team, limits)
  end

  def owner?(team)
    teams_created.include?(team)
  end
end

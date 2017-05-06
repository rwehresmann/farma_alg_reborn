class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_validation :generate_anonymous_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :anonymous_id
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates_inclusion_of :teacher, in: [true, false]
  validates_inclusion_of :admin, in: [true, false]

  has_many :exercises
  has_many :answers
  has_many :teams_created, class_name: 'Team', foreign_key: "owner_id"
  has_and_belongs_to_many :teams
  has_many :comments

  # Check if the user is the owner of a specific team.
  def owner?(team)
    teams_created.include?(team)
  end

  def teams_from_where_belongs
    teams + teams_created
  end

  # Check if the user answered all dependencies of a specific question, and so
  # is able to answer this question.
  def able_to_answer?(question, team)
    return true if or_dependencies_completed?(question, team) &&
            and_dependencies_completed?(question, team)
    false
  end

  private

    # Check if the user answered the 'OR' dependencies of a specific question.
    def or_dependencies_completed?(question, team)
      or_dependencies = question.dependencies_of_operator("OR")
      return true if or_dependencies.empty?

      or_dependencies.each { |dependency|
        return true if dependency.answered_by_user?(self, team: team, only_correct: true)
      }

      false
    end

    # Check if the user answered the 'AND' dependencies of a specific question.
    def and_dependencies_completed?(question, team)
      and_dependencies = question.dependencies_of_operator("AND")
      return true if and_dependencies.empty?

      and_dependencies.each { |dependency|
        return false unless dependency.answered_by_user?(self, team: team, only_correct: true)
      }

      true
    end

    # Generate random anonymous id.
    def generate_anonymous_id
      self.anonymous_id = SecureRandom.hex(4)
    end
end

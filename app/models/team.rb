class Team < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :password, if: :password_digest_changed?
  validates_inclusion_of :active, in: [true, false]

  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :answers
  has_and_belongs_to_many :users
  has_and_belongs_to_many :exercises

  # Check if the user is enrolled in the team (if is the owner, it's considered
  # automatically enrolled).
  def enrolled?(user)
    return false if user == owner
    users.include?(user)
  end

  # Add a user to the team and initialize an UserScore record to this user in
  # this team.
  def enroll(user)
    self.users << user
    UserScore.find_or_create_by(user: user, team: self)
  end

  # Remove the user from the team.
  def unenroll(user)
    self.users.delete(user)
  end

  def owner?(user)
    self.owner == user
  end

  def add_exercise(exercise)
    raise "This exercise already exists in this team!" if have_exercise?(exercise)
    self.exercises << exercise
  end

  def remove_exercise(exercise)
    self.exercises.delete(exercise)
  end

  def have_exercise?(exercise)
    exercises.include?(exercise)
  end
end

class Team < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :password, if: :password_digest_changed?
  validates_inclusion_of :active, in: [true, false]

  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_and_belongs_to_many :users

  # Return only the active teams.
  def self.active_teams
    Team.where(active: true)
  end

  # Check if the user is enrolled in the team (if is the owner, it's considered
  # automatically enrolled).
  def enrolled?(user)
    return true if user == owner
    users.include?(user)
  end

  # Add a user to the class.
  def enroll(user)
    self.users << user
  end

  def unenroll(user)
    self.users.delete(user)
  end
end

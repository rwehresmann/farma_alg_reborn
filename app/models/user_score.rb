class UserScore < ApplicationRecord
  validates_presence_of :score

  belongs_to :user
  belongs_to :team

  scope :by_user, -> (user = nil) do
    return unless user.present?
    where(user: user)
  end

  scope :by_team, -> (team = nil) do
    return unless team.present?
    where(team: team)
  end

  # Order the users by their score and, optionally, ranking only a top X.
  scope :top, -> (x = nil) do
    return order(score: :desc) unless x.present?
    order(score: :desc).limit(x)
  end

  # Rank the user(s) in the team(s).
  scope :rank, -> (options = {}) do
    by_user(options[:user]).by_team(options[:team]).top(options[:limit])
  end
end

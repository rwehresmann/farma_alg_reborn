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

  scope :top, -> (x = nil) do
    return unless x.present?
    limit(x)
  end

  scope :rank, -> (options = {}) do
    by_user(options[:user]).by_team(options[:team])
    .top(options[:limit]).order(score: :desc)
  end
end

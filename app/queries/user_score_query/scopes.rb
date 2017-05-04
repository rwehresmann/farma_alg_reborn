module UserScoreQuery::Scopes
  def by_users(user = nil)
    return @realtion unless user.present?
    @relation.where(user: user)
  end

  def by_team(team = nil)
    return @realtion unless team.present?
    @relation.where(team: team)
  end

  def top(limit = nil)
    @relation.order(score: :desc).limit(limit)
  end
end

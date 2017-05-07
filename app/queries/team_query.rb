class TeamQuery
  def initialize(relation = Team.all)
    @relation = relation
  end

  def active_teams
    Team.where(active: true)
  end
end

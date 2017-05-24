class UserConnectionQuery
  def initialize(relation = UserConnection.all)
    @relation = relation
  end

  def similarity_in_team(user_1:, user_2:, team:)
   record = @relation.select(:similarity)
    .where(
      user_1: user_1,
      user_2: user_2,
      team: team
    )
    .or(
      @relation.select(:similarity)
      .where(
        user_1: user_2,
        user_2: user_1,
        team: team
      )
    ).limit(1).first

    record.nil? ? nil : record.similarity
  end
end

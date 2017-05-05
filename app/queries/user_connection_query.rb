class UserConnectionQuery
  def initialize(relation = UserConnection.all)
    @relation = relation
  end

  def similarity(args = {})
   @relation.select(:similarity)
    .where(
      user_1: args[:user_1],
      user_2: args[:user_2]
    )
    .or(
      @relation.select(:similarity)
      .where(
        user_1: args[:user_2],
        user_2: args[:user_1]
      )
    ).limit(1)
  end
end

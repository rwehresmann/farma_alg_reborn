module Users
  class UserTeamsQuery
    def initialize(relation)
      @relation = relation
    end

    def call
      @relation.teams + @relation.teams_created
    end
  end
end

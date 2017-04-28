module Questions
  class AnsweredQuestionsQuery
    def initialize(relation = Question)
      @relation = relation
    end

    def call(args = {})
      @relation.joins(:answers)
        .where(where_clause(args), *ordered_values(args))
        .distinct
    end

    private

    # To build the right WHERE clause.
    ARGS_ORDER = {
                   first:  { arg: :users, field: "answers.user_id" },
                   second: { arg: :teams, field: "answers.team_id" }
                 }

    def ordered_values(args)
      [
        args[ARGS_ORDER[:first][:arg]],
        args[ARGS_ORDER[:second][:arg]],
      ].compact
    end

    def where_clause(args)
      return "#{ARGS_ORDER[:first][:field]} in (?) AND
        #{ARGS_ORDER[:second][:field]} in (?)" if args[:users] && args[:teams]
      return "answers.user_id in (?)" if args[:users]
      return "answers.team_id in (?)" if args[:teams]
      ""
    end

  end
end

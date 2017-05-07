class AnswerConnectionQuery
  def initialize(relation = AnswerConnection.all)
    @relation = relation
  end

  def connections_by_threshold(args = {})
    @relation.where(where_clause(args), *ordered_args(args))
  end

  def get_similarity(answer_1, answer_2)
    @relation.select(:similarity)
      .where(answer_1: answer_1, answer_2: answer_2)
      .or(@relation.select(:similarity)
        .where(answer_1: answer_2, answer_2: answer_1))
  end

  def connections_group(answers:, type: :with)
    raise ArgumentError, "Invalid connection type. Please, use :with or :between instead." unless valid_type?(type)
    operator = type == :with ? "OR" : "AND"
    @relation.where(
      "answer_1_id IN (?) #{operator} answer_2_id IN (?)", answers, answers)
  end

  private

  CONNECTION_TYPES = [:between, :with]

  def where_clause(args)
    raise ArgumentError,
      "You need to inform at least min or max threshold." unless threshold_informed?(args)
    return "similarity >= ? AND similarity <= ?" if args[:min] && args[:max]
    return "similarity >= ?" if args[:min]
    "similarity <= ?" if args[:max]
  end

  def ordered_args(args)
    [args[:min], args[:max]].compact
  end

  def threshold_informed?(args)
    args[:min] || args[:max]
  end

  def valid_type?(type)
    CONNECTION_TYPES.include?(type)
  end
end

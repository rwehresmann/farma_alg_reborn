class DependencyChecker
  def initialize(exercise:, user:, team:)
    @exercise = exercise
    @user = user
    @team = team
    raise "Please check the arguments! It seems they're not related." unless args_are_related?
    @questions = questions_blocked_and_unblocked
  end

  def questions_able_to_answer
    @questions[:unblocked]
  end

  def user_able_to_answer?(question)
    raise "This questions doesn't belongs to the specified exercise." unless belongs_to_exercise?(question)
    @questions[:unblocked].include?(question)
  end

  private

  # Check if the relationship between team and exercise and user are ok.
  def args_are_related?
    @team.exercises.include?(@exercise) && @team.users.include?(@user)
  end

  def belongs_to_exercise?(question)
    @exercise.questions.include?(question)
  end

  def questions_blocked_and_unblocked
    hash = { blocked: [], unblocked: [] }
    @exercise.questions.each do |question|
      key = blocked?(question) ? :blocked : :unblocked
      hash[key] << question
    end

    hash
  end

  def blocked?(question)
    return true unless or_dependencies_completed?(question) &&
      and_dependencies_completed?(question)
    false
  end

  def or_dependencies_completed?(question)
    or_dependencies = dependencies_by_operator(question, "OR")
    return true if or_dependencies.empty?

    or_dependencies.each { |dependency|
      return true if dependency.answered_by_user?(
        @user,
        team: @team,
        only_correct: true
      )
    }

    false
  end

  def and_dependencies_completed?(question)
    and_dependencies = dependencies_by_operator(question, "AND")
    return true if and_dependencies.empty?

    and_dependencies.each { |dependency|
      return false unless dependency.answered_by_user?(
        @user,
        team: @team,
        only_correct: true
      )
    }

    true
  end

  def dependencies_by_operator(question, operator)
    QuestionDependencyQuery.new(question.question_dependencies)
      .dependencies_by_operator(operator).map(&:question_2)
  end
end

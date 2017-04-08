class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.teacher?
      can :read, [Exercise, Question, TestCase]
      can :create, [Exercise, Question, TestCase, Team, Comment]

      can [:update, :destroy], Exercise do |exercise|
        exercise.user == user
      end

      can [:update, :destroy], Question do |question|
        question.exercise.user == user
      end

      can [:update, :destroy], TestCase do |test_case|
        test_case.question.exercise.user == user
      end

      can [:test_answer], Question do |question|
        question.exercise.user == user
      end

      can [:update, :destroy, :answers], Team do |team|
        user.owner?(team)
      end

      can [:show, :destroy], AnswerConnection

      can [:update, :destroy], Comment do |comment|
        comment.user == user
      end
    end

    can :read, Team do |team|
      team.enrolled?(user) || team.owner == user
    end

    can :list_questions, Team do |team|
      team.enrolled?(user)
    end

    can [:enroll], Team do |team|
      !team.enrolled?(user)
    end

    can [:unenroll], Team do |team|
      team.enrolled?(user)
    end
  end
end

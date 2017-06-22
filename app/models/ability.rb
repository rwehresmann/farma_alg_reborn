class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.teacher?
      can :read, [Exercise, Question, TestCase]
      can :create, [Exercise, Question, TestCase, Team]

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

      can [:update, :destroy, :answers, :add_or_remove_exercise, :graph], Team do |team|
        user.owner?(team)
      end

      can [:show, :destroy], AnswerConnection
    end

    can :create, Message

    can :read, Message do |message|
      message.receiver == user || message.sender == user
    end

    can :read, Team

    can :enroll, Team do |team|
      !team.enrolled?(user) && team.owner != user
    end

    can [:unenroll, :list_questions], Team do |team|
      team.enrolled?(user)
    end

    can [:rankings, :exercises, :users], Team do |team|
      team.enrolled?(user) || user.owner?(team)
    end
  end
end

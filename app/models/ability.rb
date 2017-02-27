class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.teacher?
      can :read, [Exercise, Question, TestCase]
      can :create, [Exercise, Question, TestCase, Team]

      can :manage, Exercise do |exercise|
        exercise.user == user
      end

      can :manage, Question do |question|
        question.exercise.user == user
      end

      can :manage, TestCase do |test_case|
        test_case.question.exercise.user == user
      end

      can [:update, :delete], Team do |team|
        team.owner == user
      end
    else
      can :read, [Exercise, Question]
    end

    can :read, Team do |team|
      team.enrolled?(user) || team.owner == user
    end

    can [:enroll], Team do |team|
      !team.enrolled?(user)
    end

    can [:unenroll], Team do |team|
      team.enrolled?(user)
    end
  end
end

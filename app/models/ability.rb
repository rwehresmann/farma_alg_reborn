class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.teacher?
      can :manage, [Exercise, Question, TestCase]
      can :manage, Team do |team|
        team.owner == user
      end

      can :create, Team
    else
    end

    can [:enroll], Team do |team|
      !team.enrolled?(user)
    end

    can [:unenroll], Team do |team|
      team.enrolled?(user)
    end

    can :read, Team
  end
end

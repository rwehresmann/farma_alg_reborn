class Ability
  include CanCan::Ability

  def initialize(user)
    if user.teacher?
      can :manage, [Exercise, Question, TestCase]
      can :manage, Team, owner: user
      can [:read, :create], Team
      can [:enroll], Team do |team|
        !team.enrolled?(user)
      end
      can [:unenroll], Team do |team|
        team.enrolled?(user)
      end
    end
  end
end

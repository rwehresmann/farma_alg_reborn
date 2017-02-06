require 'rails_helper'
require 'cancan/matchers'

describe "User" do
  describe "abilities" do
    subject(:ability){ Ability.new(user) }

    context "when is a teacher -->" do
      let(:user) { create(:user, :teacher) }

      it { should be_able_to(:manage, Exercise) }

      it { should be_able_to(:manage, Question) }
      it { should be_able_to(:manage, TestCase) }


      context "when is owner of the team" do
        let(:team) { create(:team, owner: user) }

        it { should be_able_to(:manage, Team) }

      end

      context "when isn't the owner of a team -->" do
        let(:team) { create(:team) }

        it { should_not be_able_to(:manage, team) }
        it { should be_able_to(:create, team) }
        it { should be_able_to(:read, team) }

        context "when unenrolled in the team" do
          it { should be_able_to(:enroll, team) }
          it { should_not be_able_to(:unenroll, team) }
        end

        context "when enrolled in the team" do
          before { team.enroll(user) }

          it { should_not be_able_to(:enroll, team) }
          it { should be_able_to(:unenroll, team) }
        end
      end
    end

    context "when is a student -->" do
      let(:user) { create(:user) }

      it { should_not be_able_to(:manage, Exercise) }
      it { should_not be_able_to(:manage, Question) }
      it { should_not be_able_to(:manage, TestCase) }
      it { should_not be_able_to(:manage, Team) }
      it { should be_able_to(:read, Team) }

      context "when unenrolled in the team" do
        let(:team) { create(:team) }
        it { should be_able_to(:enroll, team) }
        it { should_not be_able_to(:unenroll, team) }
      end

      context "when enrolled in the team" do
        let(:team) { create(:team) }
        before { team.enroll(user) }

        it { should_not be_able_to(:enroll, team) }
        it { should be_able_to(:unenroll, team) }
      end
    end
  end
end

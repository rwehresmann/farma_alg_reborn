require 'rails_helper'
require 'cancan/matchers'

describe "User" do
  describe "abilities" do
    subject(:ability){ Ability.new(user) }

    context "when is a teacher -->" do
      let(:user) { create(:user, :teacher) }

      it { should be_able_to(:create, Exercise) }
      it { should be_able_to(:read, Exercise) }
      it { should be_able_to(:create, Question) }
      it { should be_able_to(:read, Question) }
      it { should be_able_to(:create, TestCase) }
      it { should be_able_to(:read, TestCase) }
      it { should be_able_to(:create, Team) }

      context "when access his created objects" do
        let(:exercise) { create(:exercise, user: user) }
        let(:question) { create(:question, exercise: exercise) }
        let(:test_case) { create(:test_case, question: question) }
        let(:team) { create(:team, owner: user) }

        it { should be_able_to(:delete, exercise) }
        it { should be_able_to(:update, exercise) }
        it { should be_able_to(:delete, question) }
        it { should be_able_to(:update, question) }
        it { should be_able_to(:delete, test_case) }
        it { should be_able_to(:update, test_case) }
        it { should be_able_to(:delete, team) }
      end

      context "when access objects that he doesn't created -->" do
        let(:exercise) { create(:exercise) }
        let(:question) { create(:question) }
        let(:test_case) { create(:test_case) }
        let(:team) { create(:team) }
        let(:proibited_abilities) { [:update, :delete] }

        it { should_not be_able_to(proibited_abilities, exercise) }
        it { should_not be_able_to(proibited_abilities, question) }
        it { should_not be_able_to(proibited_abilities, test_case) }
        it { should_not be_able_to([:update, :delete, :unenroll, :read], team) }

        context "when is enrolled in a team" do
          before { team.enroll(user) }

          it { should be_able_to(:unenroll, team) }
          it { should be_able_to(:read, team) }
          it { should_not be_able_to(:enroll, team) }
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

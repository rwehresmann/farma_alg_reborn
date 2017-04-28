require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations -->" do
    let(:user) { build(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid with empty name" do
      user.name = ""
      expect(user).to_not be_valid
    end

    it "is invalid with empty password" do
      user.password = ""
      expect(user).to_not be_valid
    end

    it "is invalid with empty email" do
      user.email = ""
      expect(user).to_not be_valid
    end

    it "is invalid with empty anonymous id" do
      skip_before_validation_callback(user)
      user.anonymous_id = ""
      expect(user).to_not be_valid
    end

    it "is valid with valid email addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                       first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |address|
        user.email = address
        expect(user).to be_valid
      end
    end

    it "is invalid with invalid email addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com user@example..com]
      invalid_addresses.each do |address|
        user.email = address
        expect(user).to_not be_valid
      end
    end

    it "doesn't accept duplicated e-mails" do
      user_aux = build(:user)
      user_aux.email = user.email
      user_aux.save
      expect(user).to_not be_valid
    end

    it "is invalid with empty teacher flag" do
      user.teacher = ""
      expect(user).to_not be_valid
    end

    it "is invalid with empty admin flag" do
      user.admin = ""
      expect(user).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "has many exercises" do
      expect(relationship_type(User, :exercises)).to eq(:has_many)
    end

    it "has many teams created" do
      expect(relationship_type(User, :teams_created)).to eq(:has_many)
    end

    it "has and belongs to many teams" do
      expect(relationship_type(User, :teams)).to eq(:has_and_belongs_to_many)
    end
  end

  describe '#answered_correctly?' do
    let(:user) { create(:user) }
    let(:team) { create(:team, users: [user]) }
    let(:exercise) { create(:exercise, teams: [team]) }
    let(:question) { create(:question, exercise: exercise) }

    context "when is answered right" do
      before do
        # Create an incorrect answer only to check if is ignored in the query.
        create(:answer, :incorrect, team: team, user: user, question: question)
        create(:answer, :correct, team: team, user: user, question: question)
      end

      it { expect(user.answered_correctly?(question, team)).to be_truthy }
    end

    context "when isn't answered right" do
      before { create(:answer, :incorrect, team: team, user: user, question: question) }

      it { expect(user.answered_correctly?(question, team)).to be_falsey }
    end

    context "when is answered right but in another team" do
      let(:team_2) { create(:team, exercises: [exercise], users: [user]) }

      before { create(:answer, :correct, question: question, user: user, team: team_2) }

      it { expect(user.answered_correctly?(question, team)).to be_falsey }
    end
  end

  describe '#answered_question?' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    let(:question) { create(:question) }

    subject { user.answered_question?(question, team) }

    context "when answered" do
      before { create(:answer, user: user, question: question, team: team) }

      it { expect(subject).to be_truthy }
    end

    context "when unanswered" do
      it { expect(subject).to be_falsey }
    end

    context "when answered but in another team" do
      let(:team_2) { create(:team) }

      before { create(:answer, user: user, question: question, team: team_2) }

      it { expect(subject).to be_falsey }
    end
  end

  describe '#team_questions_answered' do
    before do
      user = create(:user)
      exercise = create(:exercise)
      team = create(:team, exercises: [exercise])
      team.enroll(user)
      @questions = create_pair(:question, exercise: exercise)
      2.times { create(:answer, question: @questions.first, user: user, team: team) }
      create(:answer, question: @questions.last, user: user, team: team)
      @questions_answered = user.team_questions_answered(team)
    end

    it "returns the questions that the user answered in his team" do
      expect(@questions_answered).to eq(@questions)
    end
  end

  describe '#owner?' do
    let(:user) { create(:user) }

    context "when is the owner of the team" do
      let(:team) { create(:team, owner: user) }

      it "returns true" do
        expect(user.owner?(team)).to be_truthy
      end
    end

    context "when isn't the owner of the team" do
      let(:team) { create(:team) }

      it "returns false" do
        expect(user.owner?(team)).to be_falsey
      end
    end
  end

  describe "#generate_anonymous_id" do
    let(:user) { build(:user) }

    it "generates an anonymous id to the user" do
      user.send(:generate_anonymous_id)
      expect(user.anonymous_id).to_not be_nil
    end
  end

  describe 'or_dependencies_completed?' do
    let(:user) { create(:user) }
    let(:exercise) { create(:exercise) }
    let(:team) { create(:team, users: [user], exercises: [exercise]) }

    context "when they're empty" do
      let(:question) { create(:question, exercise: exercise) }

      it "returns true" do
        received = user.send(:or_dependencies_completed?, question, team)
        expect(received).to be_truthy
      end
    end

    context "when completed" do
      let(:questions) { create_pair(:question, exercise: exercise) }

      before do
        QuestionDependency.create!(question_1: questions[0],
                                   question_2: questions[1], operator: "OR")
        create(:answer, :correct, question: questions[1], team: team, user: user)
      end

      it "returns true" do
        received = user.send(:or_dependencies_completed?, questions[0], team)
        expect(received).to be_truthy
      end
    end

    context "when aren't completed" do
      let(:questions) { create_pair(:question, exercise: exercise) }

      before do
        QuestionDependency.create!(question_1: questions[0],
                                   question_2: questions[1], operator: "OR")
        create(:answer, question: questions[1], team: team)
      end

      it "returns false" do
        received = user.send(:or_dependencies_completed?, questions[0], team)
        expect(received).to be_falsey
      end
    end
  end

  describe 'and_dependencies_completed?' do
    let(:user) { create(:user) }
    let(:exercise) { create(:exercise) }
    let(:team) { create(:team, users: [user], exercises: [exercise]) }

    context "when they're empty" do
      let(:question) { create(:question, exercise: exercise) }

      it "returns true" do
        received = user.send(:and_dependencies_completed?, question, team)
        expect(received).to be_truthy
      end
    end

    context "when completed" do
      let(:question_target) { create(:question, exercise: exercise) }
      let(:questions) { create_pair(:question, exercise: exercise) }

      before do
        QuestionDependency.create!(question_1: question_target,
                                  question_2: questions[0], operator: "AND")
        QuestionDependency.create!(question_1: question_target,
                                   question_2: questions[1], operator: "AND")
        questions.each { |question| create(:answer, :correct, user: user,
                                          question: question, team: team) }
      end

      it "returns true" do
        received = user.send(:and_dependencies_completed?, question_target, team)
        expect(received).to be_truthy
      end
    end

    context "when aren't completed" do
      let(:question_target) { create(:question, exercise: exercise) }
      let(:questions) { create_pair(:question, exercise: exercise) }

      before do
        QuestionDependency.create!(question_1: question_target,
                                   question_2: questions[0], operator: "AND")
        QuestionDependency.create!(question_1: question_target,
                                   question_2: questions[1], operator: "AND")
        create(:answer, :correct, question: questions[0], team: team)
      end

      it "returns false" do
        received = user.send(:and_dependencies_completed?, question_target, team)
        expect(received).to be_falsey
      end
    end
  end

  describe '#able_to_answer?' do
    let(:user) { create(:user) }
    let(:exercise) { create(:exercise) }
    let(:team) { create(:team, users: [user], exercises: [exercise]) }
    let(:question) { create(:question, exercise: exercise) }

    subject { user.able_to_answer?(question, team) }

    context "when all methods to check dependencies return true" do
      before do
        class << user
          def or_dependencies_completed?(a, b); true end
          def and_dependencies_completed?(a, b); true end
        end
      end

      it "returns true" do
        expect(subject).to be_truthy
      end
    end

    context "when at least one of the methods to check dependencies returns false" do
      before do
        class << user
          def or_dependencies_completed?(a, b); false end
          def and_dependencies_completed?(a, b); true end
        end
      end

      it "returns false" do
        expect(subject).to be_falsey
      end
    end
  end

  describe "Callbacks -->" do
    let(:user) { build(:user) }

    it "triggers generate_anonymous_id" do
      expect(user).to receive(:generate_anonymous_id)
      user.save
    end
  end

    private

    def skip_before_validation_callback(user)
      class << user
        def generate_anonymous_id; end
      end
    end
end

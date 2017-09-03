require 'rails_helper'

RSpec.describe Exercise, type: :model do
  describe "Validations -->" do
    let(:exercise) { build(:exercise) }

    it "is valid with valid attributes" do
      expect(exercise).to be_valid
    end

    it "is invalid with empty title" do
      exercise.title = ""
      expect(exercise).to_not be_valid
    end

    it "is invalid with empty description" do
      exercise.description = ""
      expect(exercise).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to user" do
      expect(relationship_type(Exercise, :user)).to eq(:belongs_to)
    end

    it "has many questions" do
      expect(relationship_type(Exercise, :questions)).to eq(:has_many)
    end
  end

  describe '#user_progress' do
    let(:user) { create(:user) }
    let(:exercise) { create(:exercise) }
    let(:team) { create(:team, exercises: [exercise], users: [user]) }
    let(:questions) { create_pair(:question, exercise: exercise) }

    context "when none question is right answered" do
      before { create(:question, exercise: exercise) }

      it { expect(exercise.user_progress(user, team)).to eq(0) }
    end

    context "when half of the questions are answered correctly" do
      before do
        create(:answer, :correct, question: questions.first, user: user, team: team)
        create(:answer, :incorrect, question: questions.first, user: user, team: team)
      end

      it { expect(exercise.user_progress(user, team)).to eq(50) }
    end

    context "when all questions are right answered" do
      before do
        questions.each { |question|
          # Create wrong answers only to ensure that they're ignored in the
          # presence of a right answer.
          create(:answer, :incorrect, question: question, user: user, team: team)
          create(:answer, :correct, question: question, user: user, team: team)
        }
      end

      it { expect(exercise.user_progress(user, team)).to eq(100) }
    end

    context "when the user have progress in this exercise but in another team" do
      let(:team_2) { create(:team, exercises: [exercise], users: [user]) }

      before do
        questions.each { |question|
          create(:answer, :correct, question: question, user: user, team: team_2)
        }
      end

      it { expect(exercise.user_progress(user, team)).to eq(0) }
    end
  end
end

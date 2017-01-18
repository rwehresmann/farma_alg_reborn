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

    it "has and belongs to many teams" do
      expect(relationship_type(Exercise, :teams)).to eq(:has_and_belongs_to_many)
    end
  end

  describe '#user_progress' do
    let!(:user) { create(:user) }
    let!(:exercise) { create_an_exercise_to_user(user) }

    context "when none question is right answered" do
      before { create_a_question_to_exercise(exercise) }

      it "returns 0" do
        expect(exercise.user_progress(user)).to eq(0)
      end
    end

    context "when is incomplete but has a question answered correctly" do
      before do
        question = create_a_question_to_exercise(exercise)
        create_right_answer_to_question(question, user)
        question = create_a_question_to_exercise(exercise)
        create_wrong_answer_to_question(question, user)
      end

      it "returns a value between 0 and 100" do
        expect(exercise.user_progress(user)).to eq(50)
      end
    end

    context "when all questions are right answered" do
      before do
        2.times do
          question = create_a_question_to_exercise(exercise)
          create_right_answer_to_question(question, user)
        end
      end

      it "returns 100" do
        expect(exercise.user_progress(user)).to eq(100)
      end
    end
  end
end

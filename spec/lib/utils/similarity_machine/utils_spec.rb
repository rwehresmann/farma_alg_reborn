require 'rails_helper'
require 'utils/similarity_machine/utils'

describe SimilarityMachine::Utils do
  let(:object) { Object.new.extend(described_class) }

  describe '#compare_and_shift_each' do
    subject do
      trace = []
      object.compare_and_shift_each(array, trace) { |object_1, object_2|
        trace << [object_1, object_2]
      }

      trace
    end

    context "when array size is 0" do
      let(:array) { [] }

      it "doesn't executes the loop" do
        is_expected.to be_empty
      end
    end

    context "when array size is 1" do
      let(:array) { [1] }

      it "doesn't executes the loop" do
        is_expected.to be_empty
      end
    end

    context "when array size is bigger than 1" do
      let(:array) { [1,2,3] }

      it "executes the loop matching each element with all, removing it from the array after" do
        is_expected.to eq [[1,2], [1,3], [2,3]]
      end
    end
  end

  describe '#common_questions_answered' do
    context "when there are common questions answered" do
      it "returns these questions" do
        users = create_pair(:user)
        questions = create_pair(:question)
        teams = create_pair(:team, users: users)

        users.each { |user|
          create(:answer, question: questions[0], user: user, team: teams[0])
        }

        # These answers must be ignored >>
        create(:answer, question: questions[1], user: users[0], team: teams[0])
        users.each { |user|
          create(:answer, question: questions[1], user: user, team: teams[1])
        }

        result = object.common_questions_answered(team: teams[0], users: users)
        expect(result).to eq [questions[0]]
      end
    end

    context "when there aren't common questions answered" do
      it "returns an empty array" do
        users = create_pair(:user)
        questions = create_pair(:question)
        team = create(:team, users: users)

        # These answers must be ignored >>
        create(:answer, question: questions[0], user: users[0], team: team)
        create(:answer, question: questions[1], user: users[1], team: team)

        result = object.common_questions_answered(team: team, users: users)
        expect(result).to be_empty
      end
    end
  end

  describe '#sort_similarities_desc' do
    it "returns an array of arrays with the similarities sorted desc" do
      similarities = { a: 10, b: 30, c: 20 }

      result = object.sort_similarities_desc(similarities)

      expect(result).to eq [[:b, 30], [:c, 20], [:a, 10]]
    end
  end
end

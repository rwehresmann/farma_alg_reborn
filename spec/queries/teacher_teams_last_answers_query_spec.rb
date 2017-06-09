require 'rails_helper'

describe TeacherTeamsLastAnswersQuery do
  describe '#call' do
    it "returns the last answers from the teams of the specified teacher" do
      teacher = create(:user, :teacher)
      team = create(:team, owner: teacher)
      answers = create_pair(:answer, team: team)

      # These answers should be avoided
      create_pair(:answer)

      result = described_class.new(teacher: teacher).call.to_a
      expect(result.count).to eq answers.count
      expect(result).to include(*answers)
    end
  end
end

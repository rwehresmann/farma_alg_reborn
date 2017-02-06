require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "Validations -->" do
    let(:question) { build(:question) }

    it "is valid with valid attributes" do
      expect(question).to be_valid
    end

    it "is invalid whit empty score" do
      question.score = nil
      expect(question).to_not be_valid
    end

    it "is invalid whit empty description" do
      question.description = nil
      expect(question).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to exercise" do
      expect(relationship_type(Question, :exercise)).to eq(:belongs_to)
    end

    it "has many test cases" do
      expect(relationship_type(Question, :test_cases)).to eq(:has_many)
    end

    it "has many answers" do
      expect(relationship_type(Question, :answers)).to eq(:has_many)
    end
  end

  describe '#test_all' do
    let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
    let(:results) do
      question = create(:question, test_cases_count: 2 )
      question.test_all("test_file", "pas", source_code)
    end

    it "returns an array of results, containing hashes whit the test case object, status and output" do
      expect(results.class).to eq(Array)
      expect(results.count).to eq(2)
      expect(results.first[:test_case]).to_not be_nil
      expect(results.first[:status]).to_not be_nil
      expect(results.first[:output]).to_not be_nil
    end
  end
end

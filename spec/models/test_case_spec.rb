require 'rails_helper'

RSpec.describe TestCase, type: :model do
  describe "Validations -->" do
    let(:test_case) { build(:test_case) }

    it "is valid with valid attributes" do
      expect(test_case).to be_valid
    end

    it "is invalid with empty title" do
      test_case.title = ""
      expect(test_case).to_not be_valid
    end

    it "is invalid with empty output" do
      test_case.output = ""
      expect(test_case).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to question" do
      expect(relationship_type(TestCase, :question)).to eq(:belongs_to)
    end
  end

  describe '#test' do
    let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
    subject(:result) do
      test_case = create(:test_case)
      test_case.test(file_name: SecureRandom.hex, extension: "pas",
                     source_code: source_code)
    end

    it "return an correct flag and output" do
      expect(result[:correct]).to_not be_nil
      expect(result[:output]).to_not be_nil
    end
  end
end

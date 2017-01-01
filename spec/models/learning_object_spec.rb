require 'rails_helper'

RSpec.describe LearningObject, type: :model do
  describe "Validations -->" do
    let(:learning_object) { build(:learning_object) }

    it "is valid with valid attributes" do
      expect(learning_object).to be_valid
    end

    it "is invalid with empty title" do
      learning_object.title = ""
      expect(learning_object).to_not be_valid
    end

    it "is invalid with empty description" do
      learning_object.description = ""
      expect(learning_object).to_not be_valid
    end

    it "is invalid with empty available flag" do
      learning_object.available = ""
      expect(learning_object).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to user" do
      expect(relationship_type(LearningObject, :user)).to eq(:belongs_to)
    end

    it "has many exercises" do
      expect(relationship_type(LearningObject, :exercises)).to eq(:has_and_belongs_to_many)
    end
  end
end

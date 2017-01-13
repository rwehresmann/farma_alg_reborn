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

  describe '#my_teams' do
    context "when is a student" do
      let(:user) { create(:user) }
      before do
        create_pair(:team).each { |team| team.enroll(user) }
        create_pair(:team)
      end

      it "returns only the teams where he is enrolled" do
        expect(user.my_teams).to eq(user.teams)
      end
    end

    context "when is a teacher" do
      let(:user) { create(:user, :teacher) }
      before do
        create_pair(:team, owner: user)
        create_pair(:team)
      end

      it "returns only the teams he created" do
        expect(user.my_teams).to eq(user.teams_created)
      end
    end
  end

  describe '#answered_correctly?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { create_pair(:answer, user: user, question: question) }

    context "when is answered right" do
      before { create(:answer, :correct, user: user, question: question) }

      it "returns true" do
        expect(user.answered_correctly?(question)).to be_truthy
      end
    end

    context "when isn't answered right" do
      it "returns false" do
        expect(user.answered_correctly?(question)).to be_falsey
      end
    end
  end

  describe '#unanswered?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context "when answered" do
      before { create(:answer, user: user, question: question) }

      it "returns false" do
        expect(user.unanswered?(question)).to be_falsey
      end
    end

    context "when unanswered" do
      it "returns true" do
        expect(user.unanswered?(question)).to be_truthy
      end
    end
  end
end

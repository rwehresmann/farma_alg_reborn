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

  describe "Callbacks -->" do
    let(:user) { build(:user) }

    it "triggers generate_anonymous_id" do
      expect(user).to receive(:generate_anonymous_id)
      user.save
    end
  end

  describe '#teams_to_where_belongs' do
    let(:user) { create(:user) }

    before do
      create(:team, owner: user)
      create(:team, users: [user])
    end

    it { expect(user.teams_from_where_belongs.count).to eq(2) }
  end

  private

  def skip_before_validation_callback(user)
    class << user
      def generate_anonymous_id; end
    end
  end
end

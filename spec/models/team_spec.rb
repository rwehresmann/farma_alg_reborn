require 'rails_helper'

RSpec.describe Team, type: :model do
  describe "Validations -->" do
    let(:team) { build(:team) }

    it "is valid with valid attributes" do
      expect(team).to be_valid
    end

    it "is invalid with empty name" do
      team.name = ""
      expect(team).to_not be_valid
    end

    # 'nil', not empty, because BCrypt is been used and even a empty string
    # generates a hash.
    it "is invalid with nil password" do
      team.password = nil
      expect(team).to_not be_valid
    end

    it "is invalid with empty active flag" do
      team.active = ""
      expect(team).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to user (owner)" do
      expect(relationship_type(Team, :owner)).to eq(:belongs_to)
    end

    it "has many answers" do
      expect(relationship_type(Team, :answers)).to eq(:has_many)
    end

    it "has and belongs to many users" do
      expect(relationship_type(Team, :users)).to eq(:has_and_belongs_to_many)
    end
  end

  describe '#enrolled?' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    context "when user is enrolled" do
      before { team.enroll(user) }

      it "is true" do
        expect(team.enrolled?(user)).to be_truthy
      end
    end

    context "when user isn't enrolled" do
      it "is false" do
        expect(team.enrolled?(user)).to be_falsey
      end
    end

    context "when user is the team owner" do
      let(:user) { create(:user, :teacher) }
      let(:team) { create(:team, owner: user) }

      it "is false" do
        expect(team.enrolled?(user)).to be_falsey
      end
    end
  end

  describe '#unenroll' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    before do
      team.enroll(user)
      team.unenroll(user)
    end

    it "unenroll the user" do
      expect(team.enrolled?(user)).to be_falsey
    end
  end

  describe '#enroll' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    before { team.enroll(user) }

    it { expect(team.enrolled?(user)).to be_truthy }
  end

  describe '#add_exercise' do
    context "when exercise isn't associated to the team yet" do
      let(:team) { create(:team) }
      let(:exercise) { create(:exercise) }

      before { team.add_exercise(exercise) }

      it { expect(team.exercises).to include(exercise) }
    end

    context "when exercise is already associated to the team" do
      let(:exercise) { create(:exercise) }
      let(:team) { create(:team, exercises: [exercise]) }

      subject { team.add_exercise(exercise) }

      it { expect{ subject }.to raise_error(RuntimeError) }
    end
  end

  describe '#remove_exercise' do
    let(:exercise) { create(:exercise) }
    let(:team) { create(:team, exercises: [exercise]) }

    before { team.remove_exercise(exercise) }

    it { expect(team.exercises).to_not include(exercise) }
  end

  describe '#have_exercise?' do
    context "when have" do
      let(:exercise) { create(:exercise) }
      let(:team) { create(:team, exercises: [exercise]) }

      it { expect(team.have_exercise?(exercise)).to be_truthy }
    end

    context "when haven't" do
      let(:exercise) { create(:exercise) }
      let(:team) { create(:team) }

      it { expect(team.have_exercise?(exercise)).to be_falsey }
    end
  end

  describe '#initialize_user_score' do
    let(:team) { create(:team) }

    subject { team.send(:initialize_user_score) }

    before { team.instance_variable_set("@user", create(:user)) }

    context "when it wasn't initialized already" do
      it { expect { subject }.to change(UserScore, :count).by(1) }
    end

    context "when it was initialized already" do
      before {
        create(:user_score, user: team.instance_variable_get("@user"), team: team)
      }

      it { expect { subject }.to_not change(UserScore, :count) }
    end
  end

  describe "Callbacks -->" do
    it { is_expected.to callback(:initialize_user_score).after(:enroll) }
  end
end

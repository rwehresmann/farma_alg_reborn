require 'rails_helper'

describe "Order teams", type: :feature do
  context "when user is a teacher" do
    let!(:user) { create(:user, :teacher) }
    let!(:team) { create(:team) }
    let!(:his_team) { create(:team, owner: user) }

    before do
      login_as user
      visit teams_path
    end

    context "in 'all teams' section" do
      it { expect(page).to have_selector('.box.box-solid.box-default', count: 2) }
    end

    context "in 'my teams' section" do
      before { find('#my-teams').click }

      it { expect(page).to have_selector('.box.box-solid.box-default', count: 1) }
    end
  end

  context "when user is a student" do
    let!(:user) { create(:user) }
    let!(:team) { create(:team) }
    let!(:his_team) { create(:team, users: [user]) }

    before do
      login_as user
      visit teams_path
    end

    context "in 'all teams' section" do
      it { expect(page).to have_selector('.box.box-solid.box-default', count: 2) }
    end

    context "in 'my teams' section" do
      before { find('#my-teams').click }

      it { expect(page).to have_selector('.box.box-solid.box-default', count: 1) }
    end
  end

    private

    def test_teams_display
    end
end

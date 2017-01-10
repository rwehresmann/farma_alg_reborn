require 'rails_helper'

describe "Create a team", type: :feature do
  let(:team) { build(:team) }
  before do
    login_as create(:user)
    visit new_team_url
  end

  context "whit valid attributes" do
    subject do
      fill_in "team_name", with: team.name
      fill_in "team_password", with: team.password
      fill_in "team_password_confirmation", with: team.password
      click_on "Criar"
    end

    it "creates the team" do
      expect{ subject }.to change(Team, :count).by(1)
      expect(page).to have_current_path(team_path(Team.first.id))
    end
  end

  context "whit invalid attributes -->" do
    subject do
      click_on "Criar"
    end

    it "doesn't create the exercise" do
      expect{ subject }.to change(Team, :count).by(0)
      expect(page).to have_selector("div.alert.alert-danger")
    end

    context "when password confirmation doesn't match" do
      subject do
        fill_in "team_name", with: team.name
        fill_in "team_password", with: team.password
        fill_in "team_password_confirmation", with: "wrongpass"
        click_on "Criar"
      end

      it "doesn't create the exercise" do
        expect{ subject }.to change(Team, :count).by(0)
        expect(page).to have_selector("div.alert.alert-danger")
      end
    end
  end
end

require 'rails_helper'
=begin
describe "Enroll in a team", type: :feature, js: true do
  let!(:team) { create(:team) }

  before do
    login_as create(:user)
    visit teams_path
  end

  context "with a valid password" do
    before do
      fill_in "password", with: team.password
      find('[name=commit]').click
    end

    it "redirects to team rankings page" do
      expect(page).to have_current_path(rankings_team_path(team))
      expect(page).to have_selector("div.alert.alert-success")
    end
  end

  context "with an invalid password" do
    before do
      fill_in "password", with: ""
      find('[name=commit]').click
    end

    it "informs that the password is wrong" do
      expect(page).to have_current_path(teams_path)
      expect(page).to have_content("Senha incorreta!")
    end
  end
end
=end

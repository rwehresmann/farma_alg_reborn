require 'rails_helper'

describe "Unenroll from a team", type: :feature, js: true do
  before do
    user = create(:user)
    create(:team, users: [user])
    login_as user
    visit teams_path
  end

  it "remove the link to unenroll" do
    expect(page).to_not have_selector(:link_or_button, "Cancelar matrícula!")
    expect(page).to_not have_selector(:link_or_button, "Matricular-se")
    expect(page).to have_current_path(teams_path)
  end
end

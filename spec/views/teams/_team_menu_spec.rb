require 'rails_helper'

describe "teams/_team_menu.html.erb", type: :view do
  let(:partial) { "teams/team_menu" }
  let(:user) { create(:user, :teacher) }

  before do
    allow(view).to receive_messages(current_user: user)
    allow(controller).to receive_messages(current_ability: Ability.new(user))
  end

  context "when user is the owner of the team" do
    it "renders all tabs options" do
      render partial, team: create(:team, owner: user)

      expect(rendered).to have_link("Rankings")
      expect(rendered).to have_link("Exercícios")
      expect(rendered).to have_link("Alunos matriculados")
      expect(rendered).to have_link("Grafo de manipulação")
    end
  end

  context "when team doesn't belongs to the user" do
    it "renders all tabs options" do
      render partial, team: create(:team, users: [user])

      expect(rendered).to have_link("Rankings")
      expect(rendered).to have_link("Exercícios")
      expect(rendered).to have_link("Alunos matriculados")
      expect(rendered).to_not have_link("Grafo de manipulação")
    end
  end
end

require 'rails_helper'

describe 'teams/index/_team.html.erb' do
  before do
    allow(view).to receive_messages(current_user: user)
    allow(controller).to receive_messages(current_ability: Ability.new(user))
    render 'teams/index/team', team: team
  end

  context "when the current user is enrolled" do
    let!(:user) { create(:user) }
    let!(:team) { create(:team, users: [user]) }

    it "displays team information" do
      expect(rendered).to have_content(team.name)
      expect(rendered).to have_content(team.owner.name)
    end

    it { expect(rendered).to have_link("Ver", href: rankings_team_path(team)) }
    xit { expect(rendered).to have_link("Cancelar matrícula", href: unenroll_team_path(team)) }
    it { expect(rendered).to_not have_link("Deletar") }
    it { expect(rendered).to_not have_link("Editar") }
  end

  context "when the current user isn't enrolled" do
    let!(:user) { create(:user) }
    let!(:team) { create(:team) }

    it "displays team information" do
      expect(rendered).to have_content(team.name)
      expect(rendered).to have_content(team.owner.name)
    end

    xit { expect(rendered).to have_button("Matricular-se") }
    it { expect(rendered).to_not have_link("Excluir") }
    it { expect(rendered).to_not have_link("Editar") }
    it { expect(rendered).to_not have_link("Ver") }
  end

  context "when user is a tacher" do
    let!(:user) { create(:user, :teacher) }
    let!(:team) { create(:team, owner: user) }

    it { expect(rendered).to have_link("Excluir") }
    it { expect(rendered).to have_link("Editar") }
    it { expect(rendered).to have_link("Ver") }

    it "displays team information" do
      expect(rendered).to have_content(team.name)
      expect(rendered).to have_content(team.owner.name)
    end
  end
end

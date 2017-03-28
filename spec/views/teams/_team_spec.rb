require 'rails_helper'

describe 'teams/_team.html.erb' do
  context "when the current user is enrolled" do
    let!(:user) { create(:user) }
    let!(:team) { create(:team, users: [user]) }

    before do
      allow(view).to receive_messages(current_user: user)
      allow(controller).to receive_messages(current_ability: Ability.new(user))
      render partial: 'teams/team', locals: { team: team }
    end

    it "displays team information" do
      expect(rendered).to have_content(team.name)
      expect(rendered).to have_content(team.owner.name)
    end

    it { expect(rendered).to have_link("Ver", href: team_path(user)) }
    it { expect(rendered).to have_link("Cancelar matrícula", href: unenroll_team_path(team)) }
    it { expect(rendered).to_not have_link("Deletar") }
    it { expect(rendered).to_not have_link("Editar") }
  end

  context "when the current user is unenrolled" do
    let!(:user) { create(:user) }
    let!(:team) { create(:team) }

    before do
      allow(view).to receive_messages(current_user: user)
      allow(controller).to receive_messages(current_ability: Ability.new(user))
      render partial: 'teams/team', locals: { team: team }
    end

    it "displays team information" do
      expect(rendered).to have_content(team.name)
      expect(rendered).to have_content(team.owner.name)
    end

    it { expect(rendered).to have_button("Matricular-se") }
    it { expect(rendered).to_not have_link("Excluir") }
    it { expect(rendered).to_not have_link("Editar") }
    it { expect(rendered).to_not have_link("Ver") }
  end

  context "when user is a tacher" do
    let!(:user) { create(:user, :teacher) }
    let!(:team) { create(:team, owner: user) }

    before do
      allow(view).to receive_messages(current_user: user)
      allow(controller).to receive_messages(current_ability: Ability.new(user))
      render partial: 'teams/team', locals: { team: team }
    end

    it { expect(rendered).to have_link("Excluir") }
    it { expect(rendered).to have_link("Editar") }
    it { expect(rendered).to have_link("Ver") }

    it "displays team information" do
      expect(rendered).to have_content(team.name)
      expect(rendered).to have_content(team.owner.name)
    end
  end
end

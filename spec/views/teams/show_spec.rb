require 'rails_helper'

describe "teams/show.html.erb", type: :view do
  let(:user) { create(:user, :teacher) }

  before do
    allow(view).to receive_messages(current_user: user)
    allow(controller).to receive_messages(current_ability: Ability.new(user))
  end

  context "when team belongs to the user" do
    let(:team) { create(:team, owner: user) }

    before do
      set_instace_variables
      render
    end

    it { expect(rendered).to have_link("Rankings") }
    it { expect(rendered).to have_link("Listas de exercício") }
    it { expect(rendered).to have_link("Alunos matriculados") }
    it { expect(rendered).to have_link("Grafo de manipulação") }
  end

  context "when team doesn't belongs to the user" do
    let(:team) { create(:team, users: [user]) }

    before do
      set_instace_variables
      render
    end

    it { expect(rendered).to have_link("Rankings") }
    it { expect(rendered).to have_link("Listas de exercício") }
    it { expect(rendered).to have_link("Alunos matriculados") }
    it { expect(rendered).to_not have_link("Grafo de manipulação") }
  end

    private

    def set_instace_variables
      @general_ranking = []
      @weekly_ranking = []
      @team = team
      @team_exercises = []
      @teacher_exercises = []
      @enrolled_users = []
      @incentive_ranking = []
    end
end

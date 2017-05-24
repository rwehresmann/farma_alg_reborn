require 'rails_helper'

describe 'teams/_ranking.html.erb' do
  let(:current_user) { create(:user) }
  let(:ranking) {
    UserScoreQuery.new.ranking(
      team: @team,
      limit: 5
    ).map.inject([]) { |array, obj| array << {
        user: obj.user,
        score: obj.score
      }
    }
  }

  before do
    set_ranking_data
    set_instace_variables

    allow(view).to receive_messages(current_user: current_user)
    allow(controller).to receive_messages(current_ability: Ability.new(current_user))

    render(
      'teams/rankings/ranking',
      title: "Ranking",
      ranking: ranking,
      base_score: ranking.first[:score]
    )
  end

  context "when user is the owner of the team" do
    let(:team) { create(:team, owner: current_user) }

    it "displays the badges to the three first positions" do
      badge_expectations
    end

    it "displays the users names" do
      ranking.each { |obj| expect(rendered).to have_selector("td", text: obj[:user].name) }
    end
  end

  context "when user is a student in the team" do
    let(:team) { create(:team, users: [current_user]) }

    it "displays the badges to the three first positions" do
      badge_expectations
    end

    it "displays the users anonymous ids, except when the user is himself" do
      ranking.each do |obj|
        text_to_display = obj[:user] == current_user ? obj[:user].name
                                                     : obj[:user].anonymous_id
        expect(rendered).to have_selector("td", text: text_to_display)
      end
    end
  end

  private

  def badge_expectations
    expect(rendered).to have_selector(".badge.bg-gold", text: "1º")
    expect(rendered).to have_selector(".badge.bg-silver", text: "2º")
    expect(rendered).to have_selector(".badge.bg-bronze", text: "3º")
  end

  def set_ranking_data
    4.times { create(:user_score, user: create(:user), team: team) }
    create(:user_score, user: current_user, team: team)
  end

  def set_instace_variables
    @team = team
  end
end

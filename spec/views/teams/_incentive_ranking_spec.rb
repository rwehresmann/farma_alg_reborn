require 'rails_helper'
require 'utils/incentive_ranking'

describe 'teams/_incentive_ranking.html.erb' do
  include IncentiveRanking

  let(:current_user) { create(:user) }
  let(:team) { create(:team, users: [current_user]) }

  before do
    allow(view).to receive_messages(current_user: current_user)
    allow(controller).to receive_messages(current_ability: Ability.new(current_user))

    set_data
    set_instace_variables

    render
  end

  it "shows the user row" do
    expect(rendered).to have_selector("tr.user-row td", text: current_user.name)
    expect(rendered).to have_selector("tr.user-row td div.flex-box")
  end

  it "show another users rows displaying the anonymous id" do
    users = @incentive_ranking.map { |obj| obj[:user] }

    users.each do |user|
      text_to_display = user == current_user ? user.name : user.anonymous_id
      expect(rendered).to have_selector("tr td", text: text_to_display)
    end

    expect(rendered).to have_selector("td div.flex-box", count: users.count)
  end

    private

    def set_data
      set_ranking_data
      set_answers
    end

    def set_answers
      User.all.each { |user| create(:answer, user: user, team: team) }
    end

    def set_ranking_data
      2.times { |i| create(:user_score, user: create(:user), team: team, score: i + 1) }
      create(:user_score, user: current_user, team: team, score: 3)
    end

    def set_instace_variables
      @incentive_ranking = IncentiveRanking.build(current_user, team)
      @team = team
      @current_user_index = current_user_index
    end

    def current_user_index
      record = @incentive_ranking.select { |data| data[:user] == current_user }.first
      @incentive_ranking.index(record)
    end
end

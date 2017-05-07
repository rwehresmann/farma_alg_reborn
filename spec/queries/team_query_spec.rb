require 'rails_helper'

describe TeamQuery do
  describe '#active_teams' do
    let!(:active_team) { create(:team, :active) }
    let!(:inactive_team) { create(:team, :inactive) }

    subject { described_class.new.active_teams }

    it { is_expected.to eq([active_team]) }
  end
end

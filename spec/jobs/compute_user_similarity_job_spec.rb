require 'rails_helper'

RSpec.describe ComputeUserSimilarityJob, type: :job do
  let(:team) { create(:team) }

  before do
    2.times { team.enroll(create(:user)) }
    team.users.each { |user| create(:answer, team: team, user: user) }
  end

  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'executes perform' do
    expect(UserConnection).to receive(:create!)
    perform_enqueued_jobs { job }
  end
end

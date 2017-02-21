require 'rails_helper'

RSpec.describe ComputeUserSimilarityJob, type: :job do
  let(:team) { create(:team) }

  before { 2.times { team.enroll(create(:user)) } }

  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'executes perform' do
    expect(UserConnection).to receive(:create_simetrical_record)
    perform_enqueued_jobs { job }
  end
end

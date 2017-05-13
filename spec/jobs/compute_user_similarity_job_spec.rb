require 'rails_helper'

RSpec.describe ComputeUserSimilarityJob, type: :job do
  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    create(:team, :active)

    expect { job }.to have_enqueued_job(described_class)
      .on_queue("users_similarity")
  end

  context "when performing" do
    it "creates users connections" do
      team = create(:team, :active)
      question = create(:question)
      users = create_pair(:user, teams: [team])
      users.each { |user| create(:answer, team: team, question: question) }

      expect(UserConnection).to receive(:create!)
      perform_enqueued_jobs { job }
    end
  end
end

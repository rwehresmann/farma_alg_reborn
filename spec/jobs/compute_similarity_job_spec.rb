require 'rails_helper'

RSpec.describe ComputeSimilarityJob, type: :job do
  before(:all) do
    team = create(:team)
    question = create(:question)
    2.times { @answer = create(:answer, team: team, question: question) }
  end
  subject(:job) { described_class.perform_later(@answer) }

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'executes perform' do
    expect(AnswerConnection).to receive(:create_simetrical_record)
    perform_enqueued_jobs { job }
  end
end

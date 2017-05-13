require 'rails_helper'

RSpec.describe ComputeAnswerSimilarityJob, type: :job do
  it 'queues the job' do
    answer = create(:answer)

    expect {
      described_class.perform_later(answer)
    }.to have_enqueued_job(described_class)
    .with(answer)
    .on_queue("answers_similarity")
  end

  it { expect(described_class.new.queue_name).to eq "answers_similarity" }

  context "when performing" do
    context "when none answers are found" do
      it "doesn't create answers connections" do
        expect(AnswerConnection).to_not receive(:create!)
        perform_enqueued_jobs { described_class.perform_later(create(:answer)) }
      end
    end

    context "when answers are found" do
      it "creates answers connections" do
        answers = create_pair(
          :answer,
          question: create(:question),
          team: create(:team)
        )

        expect(AnswerConnection).to receive(:create!)
        perform_enqueued_jobs { described_class.perform_later(answers.last) }
      end
    end
  end
end

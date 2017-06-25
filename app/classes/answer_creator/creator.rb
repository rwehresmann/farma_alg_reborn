module AnswerCreator
  class Creator
    attr_reader :test_cases_results

    def initialize(answer)
      @answer = answer
      @test_cases_results = run_test_cases
    end

    def create
      @answer.attempt = get_attempt_number
      @answer.correct = correct?

      ActiveRecord::Base.transaction do
        @answer.save!
        save_test_cases_results
        Scorer::Increaser.new(
          user: @answer.user,
          team: @answer.team,
          question: @answer.question
        ).increase
      end

      ComputeAnswerSimilarityJob.perform_later(@answer)
    end

    def correct?
      @test_cases_results.each { |result| return false if result[:correct] == false }
      true
    end

    private

    def save_test_cases_results
      @test_cases_results.each { |result|
        AnswerTestCaseResult.create!(
          answer: @answer,
          test_case: result[:test_case],
          output: result[:output],
          correct: result[:correct]
        )
      }
    end

    def get_attempt_number
      attempts_count = AnswerQuery.new.user_answers(
        @answer.user,
        to: { question: @answer.question, team: @answer.team }
      ).count

      attempts_count + 1
    end

    def run_test_cases
      @answer.question.test_all(
        file_name: SecureRandom.hex,
        extension: "pas",
        source_code: @answer.content
      )
    end
  end
end

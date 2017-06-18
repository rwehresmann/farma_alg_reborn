module SimilarityMachine
  class MoreRelevantAnswers
    include Utils

    def initialize(question:, users:, team:)
      @question = question
      @users = users
      @team = team
    end

    def get(limit = nil)
      similarities = search_similarities
      limit ? similarities.first(limit) : similarities
    end

    private

    def search_similarities
      answers = AnswerQuery.new.user_answers(
        @users,
        to: { question: @question, team: @team }
      ).to_a
      return [] if answers.empty?

      similarities = Hash.new(0)
      compare_and_shift_each(answers, similarities) do |answer_1, answer_2|
        similarity = answer_1.similarity_with(answer_2)
        [answer_1, answer_2].each { |answer|
          similarities[answer] += similarity
        } unless similarity.nil?
      end

      sort_similarities_desc(similarities)
    end

    def sort_similarities_desc(similarities)
      similarities.sort_by { |_k, v| -v }
    end
  end
end

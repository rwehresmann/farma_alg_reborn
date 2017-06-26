module SimilarityMachine
  class MoreRelevantAnswers
    include Utils

    def initialize(question:, users:, team:)
      @question = question
      @users = users
      @team = team
    end

    def get
      similarities = search_similarities
      similarities.select { |answers_similarity|
        answers_similarity[:similarity] >= Figaro.env.similarity_threshold.to_f
      }
    end

    private

    def search_similarities
      answers = AnswerQuery.new.user_answers(
        @users,
        to: { question: @question, team: @team }
      ).to_a
      return [] if answers.empty?

      similarities = {}
      compare_and_shift_each(answers, similarities) do |answer_1, answer_2|
        similarity = answer_1.similarity_with(answer_2)
        [answer_1, answer_2].each { |answer|
          unless similarity.nil?
            if similarities[answer]
              similarities[answer] << similarity
            else
              similarities[answer] = [similarity]
            end
          end
        }
      end

      answers_similarity = answers.each.inject([]) { |array, answer|
        array << {
          answer: answer,
          similarity: similarities[answer].avg
        } if similarities[answer]
      }

      answers_similarity
    end
  end
end

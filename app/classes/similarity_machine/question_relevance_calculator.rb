module SimilarityMachine
  class QuestionRelevanceCalculator
    def initialize(user_1:, user_2:, team:, question:)
      @user_1 = user_1
      @user_2 = user_2
      @team = team
      @question = question
    end

    def calculate
      similarities = similarities_between_users_answers
      similarities.empty? ? 0 : similarities.avg
    end

    private

    def similarities_between_users_answers
      answers = select_users_answers
      similarities = []

      answers[:user_1].each do |user_1_answer|
        answers[:user_2].each do |user_2_answer|
          similarity = user_1_answer.similarity_with(user_2_answer)
          similarities << similarity unless similarity.nil?
        end
      end
      
      similarities
    end

    def select_users_answers
      hash = {}
      hash[:user_1] = AnswerQuery.new(@user_1.answers).user_answers(
        @user_1, to: { question: @question, team: @team }
      )
      hash[:user_2] = AnswerQuery.new(@user_2.answers).user_answers(
        @user_2, to: { question: @question, team: @team }
      )

      hash
    end
  end
end

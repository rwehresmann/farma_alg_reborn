module SimilarityMachine
  module Users
    module UsersQuestionsCalculator
      # 'question_similarity' can return nil, so 'compact!' need to be called.
      def questions_similarity(questions)
        raise ArgumentError, "None questions specified." if questions.empty?
        similarities = questions.map { |question| question_similarity(question) }
        similarities.compact!

        return 0 if similarities.empty?
        similarities.avg
      end

      private

      def question_similarity(question)
        similarities = similarities_between_users_answers(question)
        return if similarities.empty?
        similarities.avg
      end

      # If the similarity between the two answers isn't already computed,
      # returns nil. So 'compact' must be called at the end to remove the nils.
      def similarities_between_users_answers(question)
        answers = select_users_answers(question)
        similarities = []

        answers[:user_1].each do |user_1_answer|
          answers[:user_2].each { |user_2_answer|
            similarities << user_1_answer.similarity_with(user_2_answer)
          }
        end

        similarities.compact
      end

      def select_users_answers(question)
        hash = {}
        hash[:user_1] = AnswerQuery.new(@user_1.answers).user_answers(
          @user_1, to: { question: question, team: @team }
        )
        hash[:user_2] = AnswerQuery.new(@user_2.answers).user_answers(
          @user_2, to: { question: question, team: @team }
        )

        hash
      end
    end
  end
end

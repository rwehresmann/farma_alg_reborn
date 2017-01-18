module Helpers
  module AnswerProcessHelper

    def create_an_exercise_to_user(user)
      create(:exercise, user: user)
    end

    def create_a_question_to_exercise(exercise)
      create(:question, exercise: exercise)
    end

    def create_right_answer_to_question(question)
      create(:test_case, :hello_world, question: question)
      create(:answer, question: question, user: create(:user))
    end

    def create_wrong_answer_to_question(question)
      create(:test_case, question: question)
      create(:answer, question: question)
    end

    def create_answer_who_not_compile_to_question(question)
      create(:test_case, question: question)
      create(:answer, :invalid_content, question: question)
    end
  end
end

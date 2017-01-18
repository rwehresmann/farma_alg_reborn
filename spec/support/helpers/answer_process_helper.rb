module Helpers
  module AnswerProcessHelper
    # Note: when we say "create a right answer to question" it means that is
    # added a test case to question (who should have none at this point) where
    # the desired output is "Hello, world.". The factory answer receives as
    # default content the pascal program to output  this sentence. In other
    # hand, when we sar "create a wrong answer to question" whe create a answer
    # wo is compiled succesfully, but to the question is added a test case who
    # doesn't return "Hello, worl.", and so the answer is evaluated as wrong.

    def create_an_exercise_to_user(user)
      create(:exercise, user: user)
    end

    def create_a_question_to_exercise(exercise)
      create(:question, exercise: exercise)
    end

    def create_right_answer_to_question(question, user = nil)
      create(:test_case, :hello_world, question: question)
      user ||= create(:user)
      create(:answer, question: question, user: user)
    end
    def create_wrong_answer_to_question(question, user = nil)
      
      create(:test_case, question: question)
      user ||= create(:user)
      create(:answer, question: question, user: user)
    end

    def create_answer_who_not_compile_to_question(question, user = nil)
      create(:test_case, question: question)
      user ||= create(:user)
      create(:answer, :invalid_content, question: question, user: user)
    end
  end
end

module Helpers
  module AnswerProcessHelper

    # A question without test cases make an answer always be evaluated as
    # "right" (at least it has compilation errors).
    def create_right_answer_to_user_exercise(user, exercise = nil)
      exercise ||= create_an_exercise_to_user(user)
      question = create_a_question_to_exercise(exercise)
      create_right_answer_to_question(question)
    end

    # Setting a valid source to avoid compilation errors.
    def create_right_answer_to_question(question)
      source_code = File.open("spec/support/files/hello_world.pas").read
      create(:answer, content: source_code, question: question, user: question.exercise.user)
    end

    def create_an_exercise_to_user(user)
      create(:exercise, user: user)
    end

    def create_a_question_to_exercise(exercise)
      create(:question, exercise: exercise)
    end

    # The desired output in a test case factory isn't equal to the output
    # received when answer factory is compiled and executed. So, adding a test
    # case to the question make a answer be avaluated as "wrong".
    def create_wrong_answer_to_question(question)
      create_a_test_case_to_question(question)
      create(:answer, question: question, user: question.exercise.user)
    end

    def create_a_test_case_to_question(question)
      create(:test_case, question: question)
    end
  end
end

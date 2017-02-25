module Helpers
  module AnswerProcessHelper
    # Note: when we say "create a right answer to question" and 'callbacks' is
    # true it means that is added a test case to question (who should have none
    # at this point) where the desired output is "Hello, world.". The factory
    # answer receives as default content the pascal program to output this
    # sentence. In other hand, when we sar "create a wrong answer to question"
    # and 'callbacks' is true, whe create a answer wo is compiled succesfully,
    # but to the question is added a test case who doesn't return
    # "Hello, world.", and so the answer is evaluated as wrong. To all cases,
    # when 'callbacks' is false, the custom callbacks from answer object aren't
    # called and the attributes are setted automatically (correct,
    # compilation_error).

    def create_an_exercise_to_user(user = nil)
      user ||= create(:user)
      create(:exercise, user: user)
    end

    def create_a_question_to_exercise(exercise)
      create(:question, exercise: exercise)
    end

    def create_right_answer_to_question(question, options = { user: nil, team: nil, callbacks: false })
      user = get_user(options[:user])
      team = get_team(options[:team])

      if options[:callbacks]
        create(:test_case, :hello_world, question: question)
        return create(:answer, :whit_custom_callbacks, question: question,
                      user: user, team: team)
      end
      create(:answer, :correct, question: question, user: user, team: team)
    end

    def create_wrong_answer_to_question(question, options = { user: nil, team: nil, callbacks: false })
      user = get_user(options[:user])
      team = get_team(options[:team])

      if options[:callbacks]
        create(:test_case, question: question)
        return create(:answer, :whit_custom_callbacks, question: question,
                      user: user, team: team)
      end
      create(:answer, question: question, user: user, team: team)
    end

    def create_answer_whit_compilation_error_to_question(question, options = { user: nil, callbacks: false })
      user = get_user(options[:user])
      if options[:callbacks]
        create(:test_case, question: question)
        return create(:answer, :invalid_content, :whit_custom_callbacks, question: question, user: user)
      end
      create(:answer, :invalid_content, :whit_custom_callbacks, question: question, user: user)
    end

    # Used as an auxiliary method in the other methods of this helper.
    def get_user(user = nil)
      return user if user
      create(:user)
    end

    def get_team(team = nil)
      return team if team
      create(:team)
    end
  end
end

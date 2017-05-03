module IncentiveRanking::GhostUser
  class Builder
    # base_data is the data user to analize how to create the next ghost user.
    def initialize(base_data:, team:)
      @base_data = base_data
      @team = team
    end

    # base_data changes when number is > 1. In these cases, the last ghost_user
    # will be always the base_data, because the logic of the incentive ranking
    # is always create a ghost user a little bit worst than the last.
    def build(number)
      number.times.inject([]) do |ghost_users|
        answers = create_answers
        @base_data = create_incentive_ranking_object(answers)
        ghost_users << @base_data
      end
    end

    private

    # It's used to calculate the number of answers to create to the ghost user.
    ANSWER_VARIATIONS  = [0.7, 0.8, 0.85, 0.95, 1.1, 1.15]
    # It's used to calculate the score and number of correct answers to the
    # ghost user.
    GENERAL_VARIATIONS = [0.7, 0.8, 0.9, 1]

    def number_of_answers_to_create
      answers_number = @base_data[:answers].count
      answers_number == 0 ? 0 : (answers_number * ANSWER_VARIATIONS.sample).ceil
    end

    # Always less or equal to the number of correct answers of the base_data.
    def number_of_correct_answers_to_create
      number = 0
      @base_data[:answers].each { |answer| number += 1 if answer.correct }
      number == 0 ? 0 : (number * GENERAL_VARIATIONS.sample).floor
    end

    def question_to_answer
      exercise = @team.exercises.sample
      exercise.questions.sample
    end

    # It creates first the correct number of correct answers based in
    # the base_data, and completes the rest with wrong answers. After that
    # shuffle the result to make the sequence of answers more convincing.
    def create_answers
      correct_answers_number = number_of_correct_answers_to_create
      answers_number = number_of_answers_to_create

      answers_number.times.inject([]) do |array|
        if correct_answers_number > 0
          correct = true
          correct_answers_number -= 1
        else
          correct = false
        end
        array << create_answer(correct)
      end.shuffle
    end

    def create_answer(correct)
      question_to_answer.answers.build(correct: correct)
    end

    def create_incentive_ranking_object(answers)
      {
        user: User.new(anonymous_id: SecureRandom.hex(4)),
        answers: answers,
        score: (@base_data[:score] * GENERAL_VARIATIONS.sample).floor
       }
    end
  end
end

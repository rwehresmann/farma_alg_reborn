module SimilarityMachine
  module Utils
    def common_questions_answered(users:, team:)
      groups = []

      compare_and_shift_each(users, groups) do |user_1, user_2|
        users_questions = [user_1, user_2].map { |user|
          QuestionQuery.new.questions_answered_by_user(user, team: team).to_a
        }
        groups << users_questions.common_arrays_values
      end

      groups.common_arrays_values
    end

    def compare_and_shift_each(array, groups)
      array_copy = array.dup
      array.count.times do
        object_1 = array_copy.shift
        array_copy.each { |object_2| yield(object_1, object_2) }
      end
    end
  end
end

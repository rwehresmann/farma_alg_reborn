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
        return if array_copy.length <= 1
        object_1 = array_copy.shift
        array_copy.each { |object_2| yield(object_1, object_2) }
      end
    end

    def sort_similarities_desc(similarities)
      similarities.sort_by { |_k, v| -v }
    end
  end
end

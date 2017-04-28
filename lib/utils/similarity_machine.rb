require 'extensions/array'

module SimilarityMachine
  include Amatch

  # Calculate the similarity between two ansers.
  def answers_similarity(answer_1, answer_2)
    content_sim = source_code_similarity(answer_1, answer_2)
    test_cases_sim = test_cases_output_similarity(answer_1, answer_2)
    answers_similarity_formula(content_sim, test_cases_sim)
  end

  # Call Stanford Moss server to calculate source code similarity. When Moss
  # conclude that non similarity exists, returns an empty array, and in this
  # case, similarity is 0.
  def source_code_similarity(answer_1, answer_2)
    moss = Moss.new(000000000)
    moss.options[:language] = "pascal"

    moss.add_content(answer_1.content)
    moss.add_content(answer_2.content)

    url = moss.check
    results = moss.extract_results(url)

    return 0 if results.empty?
    results.first.first[:pct]
  end

  # Use PairDistance algorithm because is better to calculate similarity of
  # sentences (for single words works fine too).
  def string_similarity(string_1, string_2)
    to_match = PairDistance.new(string_1)
    to_match.match(string_2) * 100
  end

  # Check similarity of test cases results. It's not the most common scenario,
  # but sometimes both answers of the same question pass through different test
  # cases (because someone changed the question test cases in some point).
  # Because of that, we check for common test cases.
  def test_cases_output_similarity(answer_1, answer_2)
    similarities = []
    test_cases = answer_1.test_cases.to_a.common_values(answer_2.test_cases.to_a)

    test_cases.each do |test_case|
      result_1 = AnswerTestCaseResult.result(answer_1, test_case)
      result_2 = AnswerTestCaseResult.result(answer_2, test_case)
      similarities << string_similarity(result_1.output, result_2.output)
    end

    return 0 if similarities.empty?
    similarities.avg
  end

  # Calculate the similarity between two users of the same team.
  def users_similarity(user_1, user_2, team)
    questions = common_questions_answered([user_1, user_2], team)
    return 0 if questions.empty?

    similarities = questions_similarity(questions, user_1, user_2, team)
    users_similarity_formula(similarities, questions.count)
  end

  # Get the similarity of a specific group of questions that the two users
  # answered in the same team.
  def questions_similarity(questions, user_1, user_2, team)
    raise "No questions specified" if questions.empty?

    similarities = questions.each.inject([]) { |array, question|
      array << question_similarity(question, user_1, user_2, team)
    }

    similarities.compact!
    return 0 if similarities.empty?
    similarities.avg
  end

  # Get the most relevante question, for a specific group of users, from a
  # specific team.
  def most_representative_question(users, team)
    questions = common_questions_answered(users, team)
    return if questions.empty?

    similarities = Hash.new(0)
    each_object(users, similarities) do |user_1, user_2|
      questions.each do |question|
        similarity = question_similarity(question, user_1, user_2, team)
        similarities[question] += similarity unless similarity.nil?
      end
    end

    most_representative(similarities)
  end

  # Get the most representative answer from a specific question, based in the
  # answers of a group of users,from a specific team.
  def most_representative_answer(question, users, team)
    answers = Answer.by_question(question).by_user(users).by_team(team).to_a

    similarities = Hash.new(0)
    each_object(answers, similarities) do |answer_1, answer_2|
      similarity = AnswerConnection.similarity(answer_1, answer_2)
      similarities[answer_1] += similarity unless similarity.nil?
    end

    most_representative(similarities)
  end

    private

    # Get the similarity from two users from the same team to the same question.
    def question_similarity(question, user_1, user_2, team)
      user_1_answers = user_1.answers.where(question: question, team: team, user: user_1)
      user_2_answers = user_2.answers.where(question: question, team: team, user: user_2)

      similarities = []
      user_1_answers.each do |user_1_answer|
        user_2_answers.each do |user_2_answer|
          similarities << AnswerConnection.similarity(user_1_answer, user_2_answer)
        end
      end

      # If the similarity between the two answers isn't already computed, returns
      # nil. So 'compact!' must be called to remove the nils.
      similarities.compact!
      return if similarities.empty?
      users_question_similarity_formula(similarities)
    end

    # Get the common questions answered between two users of a team.
    def common_questions_answered(users, team)
      groups = []
      answered_questions_query = Questions::AnsweredQuestionsQuery.new
      each_object(users, groups) do |user_1, user_2|
        user_1_questions = answered_questions_query.call(
          users: user_1,
          teams: team
        ).to_a
        user_2_questions = answered_questions_query.call(
          users: user_2,
          teams: team
        ).to_a
        groups << user_1_questions.common_values(user_2_questions)
      end

      groups.common_arrays_values
    end

    # calculates users similarity.
    def users_similarity_formula(questions_similarity, questions_count)
      questions_similarity.fdiv(questions_count)
    end

    # Calculates the question similarity between two users.
    def users_question_similarity_formula(similarities)
      similarities.avg
    end

    # Calculates the similarity between two answers.
    def answers_similarity_formula(content_sim, test_cases_sim)
      0.4 * content_sim + 0.6 * test_cases_sim if test_cases_sim
    end

    # Based on a hash of values, return the most representative of all
    # (this is, the biggest).
    def most_representative(values)
      values.key(values.values.max)
    end

    # Auxiliar structure created to use in the comparation of all array
    # elements. This comparation is simetrical (if I test a[0] whit a[1], a[1]
    # whit a[0] will not be tested).
    def each_object(array, similarities)
      array_copy = array.dup
      array.count.times do
        object_1 = array_copy.shift
        array_copy.each { |object_2| yield(object_1, object_2) }
      end
    end
end

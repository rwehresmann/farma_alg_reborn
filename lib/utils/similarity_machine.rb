require 'extensions/array'

module SimilarityMachine
  include Amatch

  # Rules:
  # - If both answers have compilation error, the most interesting is return
  #   the compiler output similarity;
  # - If at least one answer have compilation error, the most interesting is
  #   return the source code similarity;
  # - Any other case we don't have compilation error, and in this case the most
  #   interesting is return the answers formula.
  def answers_similarity(answer_1, answer_2)
    if answer_1.compilation_error? && answer_2.compilation_error?
      return compiler_output_similarity(answer_1, answer_2)
    elsif answer_1.compilation_error? || answer_2.compilation_error?
      return source_code_similarity(answer_1, answer_2)
    else
      content_sim = source_code_similarity(answer_1, answer_2)
      test_cases_sim = test_cases_output_similarity(answer_1, answer_2)
      answers_formula(content_sim, test_cases_sim)
    end
  end

  # Check the similarity between the compiler output for each answer.
  def compiler_output_similarity(answer_1, answer_2)
    answer_1_error = get_error(answer_1.compiler_output)
    answer_2_error = get_error(answer_2.compiler_output)
    string_similarity(answer_1_error, answer_2_error)
  end

  # Call Stanford Moss server to calculate source code similarity. When Moss
  # conclude that non similarity exists, return an empty array, and in this
  # case, similarity is considered 0.
  def source_code_similarity(answer_1, answer_2)
    moss = Moss.new(000000000)
    moss.options[:language] = "pascal"

    moss.add_content(answer_1.content)
    moss.add_content(answer_2.content)

    url = moss.check
    results = moss.extract_results(url)

    if results.empty?
      0
    else
      results.first.first[:pct]
    end
  end

  # Use PairDistance algorithm because is better to calculate similarity of
  # sentences (for single words works fine too).
  def string_similarity(string_1, string_2)
    to_match = PairDistance.new(string_1)
    to_match.match(string_2) * 100
  end

  # Check similarity of test case results. It's not the most common scenario,
  # but sometimes both answer of the same question pass through different test
  # cases (because someone changed the question test cases in some point).
  # Because that we check for common test cases.
  def test_cases_output_similarity(answer_1, answer_2)
    similarity = []
    test_cases = answer_1.test_cases.to_a.common_values(answer_2.test_cases.to_a)

    test_cases.each do |test_case|
      result_1 = AnswerTestCaseResult.result(answer_1, test_case)
      result_2 = AnswerTestCaseResult.result(answer_2, test_case)
      similarity << string_similarity(result_1.output, result_2.output)
    end

    return 0 if similarity.empty?
    similarity.avg
  end

  # Calculate the similarity between two users of the same team.
  def users_similarity(user_1, user_2, team)
    questions = common_questions_answered([user_1, user_2], team)
    similarities = questions_similarity(questions, user_1, user_2, team)
    users_formula(similarities, questions.count)
  end

  # Get the similarity of a specific group of questions that the two users
  # answered in the same team.
  def questions_similarity(questions, user_1, user_2, team)
    similarities = []
    questions.each do |question|
      similarities << question_similarity(question, user_1, user_2, team)
    end
    similarities.compact!
    similarities.avg
  end

  # Get the most relevante question for a specific group of users, from a
  # specific team.
  def most_representative_question(users, team)
    questions = common_questions_answered(users, team)
    return if questions.empty?

    similarities = Hash.new(0)

    count = users.count
    count.times do
      user_1 = users.shift
      users.each do |user_2|
        questions.each do |question|
          similarity = question_similarity(question, user_1, user_2, team)
          similarities[question] += similarity
        end
      end
    end

    most_representative(similarities)
  end

  # Get the most representative answer based in the answers of a group ou users,
  # from a specific team to a specific question.
  def most_representative_answer(question, users_component, team)
    answers = Answer.where(question: answer.question, user: users, team: team)

    similarities = Array.new(0)
    count = answers.count
    count.times do
      answer_1 = answers.shift
      answers.each do |answer_2|
        similarities[:answer_1] += AnswerConnection.similarity(answer_1, answer_2)
      end
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

      users_question_formula(similarities)
    end

    # Get the lines where the error is described.
    def get_error(content)
      content.split("\n").grep(/(?i)error/).join("\n")
    end

    # Get the common questions answered between two users of a team.
    def common_questions_answered(users, team)
      users_copy = users.dup
      groups = []
      users.count.times do
        user_1 = users_copy.shift
        users_copy.each do |user_2|
          user_1_questions = user_1.team_questions_answered(team)
          user_2_questions = user_2.team_questions_answered(team)
          groups << user_1_questions.common_values(user_2_questions)
        end
      end

      common_answers = groups.shift
      groups.each { |group| common_answers = common_answers.common_values(group) }

      common_answers
    end

    # Returns the users similarity.
    def users_formula(questions_similarity, questions_count)
      questions_similarity.fdiv(questions_count)
    end

    # Returns the question similarity between two users.
    def users_question_formula(similarities)
      return if similarities.empty?
      similarities.avg
    end

    # Compute answers similarity.
    def answers_formula(content_sim, test_cases_sim)
      0.4 * content_sim + 0.6 * test_cases_sim if test_cases_sim
    end

    # Based on a hash of similarities, return the most representative of all
    # (this is, the biggest).
    def most_representative(similarities)
      similarities.key(similarities.values.max)
    end

=begin
    def each_similarity(array, similarities = [], &block)
      length = array.count
      length.times do
        object_1 = array.shift
        array.each { |object_2| &block }
      end
    end
=end
end

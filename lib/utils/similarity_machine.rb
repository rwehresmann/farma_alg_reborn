module SimilarityMachine
  include Amatch

  # Rules:
  # - If at least one answer have compilation error, call
  #   'compiler_output_similarity';
  # - If none answer have compilation error, call source_code_similarity.
  # The formula at the end compute the end similarity.
  def answers_similarity(answer_1, answer_2)
    if !answer_1.correct? && !answer_2.correct?
      content_sim = compiler_output_similarity(answer_1, answer_2)
    else
      content_sim = source_code_similarity(answer_1, answer_2)
    end

    test_cases_sim = test_cases_output_similarity(answer_1, answer_2)

    0.4 * content_sim + 0.6 * test_cases_sim
  end

  # Check the similarity between the compiler output for each answer.
  def compiler_output_similarity(answer_1, answer_2)
    string_similarity(answer_1.compiler_output, answer_2.compiler_output)
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
    test_cases = common_test_cases(answer_1.test_cases, answer_2.test_cases)
    test_cases.each do |test_case|
      result_1 = AnswerTestCaseResult.result(answer_1, test_case)
      result_2 = AnswerTestCaseResult.result(answer_2, test_case)
      similarity << string_similarity(result_1.output, result_2.output)
    end

    return 0 if similarity.empty?
    similarity.reduce(:+).to_f / similarity.size
  end

  # User exclusively in 'test_cases_output_similarity' method, to filter the
  # test cases to check when the answers haven't been tested in all the same
  # test cases. In this case, we would like to check t
  def common_test_cases(test_cases_1, test_cases_2)
    not_common = []
    not_common += test_cases_1 - test_cases_2
    not_common += test_cases_2 - test_cases_1
    (test_cases_1 + test_cases_2 - not_common).uniq
  end
end

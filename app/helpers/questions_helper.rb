module QuestionsHelper
  # Pluralize test case text.
  def pluralize_test_cases(count)
    return "#{count} casos de testes cadastrados" if count >= 0
    "#{count} caso de teste cadastrado"
  end
end

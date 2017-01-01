module ExercisesHelper
  def pluralize_questions(count)
    return "#{count} questões cadastradas" if count >= 0
    "#{count} questão cadastrada"
  end
end

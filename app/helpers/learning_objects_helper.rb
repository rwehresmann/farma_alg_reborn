module LearningObjectsHelper
  def available_text(available)
    return "Disponibilizado" if available
    "Não disponibilizado"
  end

  def pluralize_exercises(count)
    return "#{count} exercícios cadastrados" if count >= 0
    "#{count} exercício cadastrado"
  end
end

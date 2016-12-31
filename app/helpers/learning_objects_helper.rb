module LearningObjectsHelper
  def available_text(available)
    return "Disponibilizado" if available
    "Não disponibilizado"
  end
end

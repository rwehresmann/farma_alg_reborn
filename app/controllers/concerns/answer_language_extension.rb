module AnswerLanguageExtension
  extend ActiveSupport::Concern

  def answer_language_extension(question)
    if question.answer_language_allowed == "pascal"
      "pas"
    elsif question.answer_language_allowed == "c"
      "c"
    end
  end
end

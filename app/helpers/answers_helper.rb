module AnswersHelper
  def correct_icon(answer)
    return "fa fa-check" if answer.correct?
    "fa fa-close"
  end

  def correct_style(boolean)
    return "success" if boolean == true
    "danger"
  end
end

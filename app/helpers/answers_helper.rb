module AnswersHelper
  def correct_icon(answer)
    return "fa fa-check" if answer.correct?
    "fa fa-close"
  end

  def correct_box_style(answer)
    return "box-success" if answer.correct?
    "box-danger"
  end
end

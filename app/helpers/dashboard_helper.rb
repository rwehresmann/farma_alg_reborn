module DashboardHelper
  def answer_status_label(answer)
    return raw "<span class='badge bg-green'>Correta</span>" if answer.correct
    raw "<span class='badge bg-red'>Incorreta</span>"
  end
end

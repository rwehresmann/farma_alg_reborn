module TeamsHelper
  # Returns index corresponding position in the ranking.
  def position(index)
    if index == 0
      raw "<span class='badge bg-gold'>1º</span>"
    elsif index == 1
      raw "<span class='badge bg-silver'>2º</span>"
    elsif index == 2
      raw "<span class='badge bg-bronze'>3º</span>"
    else
      "#{index + 1}º"
    end
  end

  # Get the percentage of representativeness of the score, considering the
  # base score.
  def score_representation(base_score, score)
    "#{(100 * score) / base_score}%"
  end

  def incentive_ranking_position(index, current_user_index)
    if index > current_user_index
      raw "<i class='fa fa-arrow-circle-down'></i>"
    elsif index == current_user_index
      raw "<i class='fa fa-angle-double-right'></i>"
    else
      raw "<i class='fa fa-arrow-circle-up'></i>"
    end
  end

  # Return the class to put in answer div.
  def answer_class(answer)
    return "correct" if answer.correct?
    "incorrect"
  end

  # Answer information to display in tootipe of each answer div.
  def answer_info(answer)
    result = answer.correct? ? "Correta" : "Incorreta"
    "<dl>
      <dt>Questão</dt>
      <dd>#{answer.question.title}<br></br></dd>
      <dt>Exercício</dt>
      <dd>#{answer.question.exercise.title}<br></br></dd>
      <dt>Status da resposta</dt>
      <dd>#{result}</dd>
    </dl>"
  end

  # Verify if the anonymous id or the user name should be displaied.
  def name_to_display(user, team)
    return user.name if current_user.owner?(team) || current_user == user
    user.anonymous_id
  end
end

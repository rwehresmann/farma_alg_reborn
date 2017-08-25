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
    return 0 if base_score == 0
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

  def incentive_ranking_feedback
    user_score = UserScore.where(user: current_user, team: @team).first
    positions_balance =
      user_score.start_position_on_day.nil? || user_score.position.nil? ? 0 :
      user_score.start_position_on_day - user_score.position

    if positions_balance == 1
      raw "<div class='pull-right' style='color: green'>Você avançou #{positions_balance} posição no dia de hoje</div>"
    elsif positions_balance > 1
      raw "<div class='pull-right' style='color: green'>Você avançou #{positions_balance} posições no dia de hoje</div>"
    elsif positions_balance == 0
      raw "<div class='pull-right' style='color: green'>Você não avançou mas também não perdeu nenhuma posição no dia de hoje</div>"
    else
      lost_positions = positions_balance.abs

      if lost_positions > 1
        raw "<div class='pull-right' style='color: red'>Você perdeu #{lost_positions} posições no dia de hoje</div>"
      else
        raw "<div class='pull-right' style='color: red'>Você perdeu #{lost_positions} posição no dia de hoje</div>"
      end
    end
  end

  def question_score_title(question)
    if question.operation == "task"
      "variável"
    else
      "fixo"
    end
  end
end

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
end

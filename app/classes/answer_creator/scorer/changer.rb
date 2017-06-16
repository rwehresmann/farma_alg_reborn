module AnswerCreator::Scorer
  class Changer
    def initialize(answer)
      @answer = answer
    end

    def change
      AnswerCreator::Scorer::Increaser.new(
        user: @answer.user,
        team: @answer.team,
        question: @answer.question
      ).increase if should_be_changed?
    end

    private

    def should_be_changed?
      return false unless @answer.correct?

      answers_count = Answer.select(1)
        .where(
          user: @answer.user,
          team: @answer.team,
          question: @answer.question
        ).limit(2).count

      number_to_check = @answer.new_record? ? 0 : 1
      answers_count == number_to_check ? true : false
    end
  end
end

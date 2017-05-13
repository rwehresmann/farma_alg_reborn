module Helpers::AnswersHashHelper
  # answers[:user_x][team_x][question_x] = get answer from user_x, from team_x
  # to question_x. This is a easier structure to get the answers and create the
  # connections in the tests.
  def answers_hash(users:, teams:, questions:)
    answers = {}
    users.each_with_index do |user, user_idx|
      answers["user_#{user_idx}".to_sym] = {}
      teams.each_with_index do |team, team_idx|
        answers["user_#{user_idx}".to_sym]["team_#{team_idx}".to_sym] = {}
        questions.each_with_index do |question, question_idx|
          answers["user_#{user_idx}".to_sym]["team_#{team_idx}".to_sym].merge!(
            "question_#{question_idx}": create(
              :answer, team: team, user: user, question: question
            )
          )
        end
      end
    end

    answers
  end
end

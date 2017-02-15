class EarnedScore < ApplicationRecord
  validates_presence_of :score

  belongs_to :user
  belongs_to :question
  belongs_to :team

  scope :by_user, -> (user = nil) do
    return unless user.present?
    where(user: user)
  end

  scope :by_team, -> (team = nil) do
    return unless team.present?
    where(team: team)
  end

  scope :by_question, -> (question = nil) do
    return unless question.present?
    where(question: question)
  end

  scope :starting_from, -> (date = nil) do
    return unless date.present?
    where("created_at >= ?", date)
  end

  # For future features, it coul be interesting make this method generic,
  # ranking not only the users, but also teams and questions.
  def self.rank_user(options = {})
    records = by_user(options[:user]).by_team(options[:team])
             .by_question(options[:question])
             .starting_from(options[:starting_from])
    return build_ranking(records).first(options[:limit]) if options[:limit]
    build_ranking(records)
  end

    private

    # Get all the users (not repeated) present in a specific group of records
    # (or in the hole table).
    def self.select_users(records = nil)
      return records.select(:user_id).distinct.map(&:user) unless records.nil?
      select(:user_id).distinct.map(&:user)
    end

    # Based on the records passed build an array with users ranking, based in
    # the sum of its scores, returning the array in descendent order. 
    def self.build_ranking(records)
      ranking = []
      select_users(records).each do |user|
        ranking << { user: user, score: records.where(user: user).sum(:score) }
      end

      ranking.sort_by { |_k, v| v }.reverse
    end
end

module IncentiveRanking
  DIRECTIONS_ORDER = [:downto, :upto]

  class << self

    # Build the ranking in an array of hashes, including the last answers (the
    # limit of answers is specified whit the option ':answers' in the limits
    # hash argument) of the users of the ranking.
    def build(user, team, limits = {})
      ranking = rank(user, team, limits)

      ranking.each.inject([]) do |array, user_score|
        answers = Answer.by_team(team).by_user(user_score.user)
                  .created_last.limit(limits[:answers])
        array << { user: user_score.user, score: user_score.score, answers: answers }
      end
    end

      private

      def needs_ghost_users?(user, ranking, limits)
        return true if limits[:downto] != 0 && ranking.last.user_id == user.id
        false
      end

      # Create the user score ranking.
      def rank(user, team, limits = {})
        team_records = UserScore.rank(team: team)
        ranking = initialize_ranking(team_records, user)
        selected_index = user_index(team_records, user)

        DIRECTIONS_ORDER.each do |direction|
          break if team_records.count == 1
          half = desired_records(team_records, selected_index, direction, limits[direction])
          ranking = join_records(ranking, half, direction) unless half.nil?
        end

        ranking
      end

      def last_placed?(user, ranking)
        ranking.last.user == user
      end

      # Based in the UserScore records passed, find the record with the
      # selected user and return the array index from where the record is.
      def user_index(records, user)
        selected = records.where(user: user).first
        raise "User not found in the records." if selected.nil?
        records.index(selected)
      end

      # Based in the UserScore records, get the last array index considering
      # the direction (that is, 0 if "downto" or the array last index if
      # "upto").
      def array_last_index(records, direction)
        direction == :downto ? 0 : records.index(records.last)
      end

      # selected_idx "break the table in the middle" (in principle, but it can
      # be from or close an edge too), and according direction, count the
      # number of records in this "half", desconsidering the selected_idx
      # itself (that's why we substract 1 at the end).
      def number_of_records(records, selected_index, direction)
        last_index = array_last_index(records, direction)
        selected_index.send(direction, last_index).count - 1
      end

      # Considering the specified limit (or not if is nil) and the direction,
      # get the last array index wo represents the last UserScore record to
      # select between the specified records.
      def last_index_to_get(records, selected_index, direction, limit = nil)
        operator = get_operator(direction)
        records_to_get = number_of_records(records, selected_index, direction)
        return if records_to_get.zero?
        limit.nil? || limit > records_to_get ? array_last_index(records, direction) :
                                               (selected_index.send(operator, limit))
      end

      # Based on the selected index, direction and limit, calculate the array
      # last index to get, use it to defined the index records range and get
      # the records between this range.
      def desired_records(records, selected_index, direction, limit = nil)
        return if selected_index == array_last_index(records, direction)
        index_range = []
        index_range << selected_index.send(get_operator(direction), 1)
        index_range << last_index_to_get(records, selected_index, direction, limit)
        index_range.sort!
        index_range[0].upto(index_range[1]).inject([]) { |array, idx| array << records[idx] }
      end

      # In some places is needed to sum or substract the indexes. This is
      # determined by the direction.
      def get_operator(direction)
        direction == :downto ? :- : :+
      end

      # Join records according the specified direction.
      def join_records(array, to_add, direction)
        return (to_add + array) if direction == :downto
        (array + to_add)
      end

      def initialize_ranking(records, user)
        [records.where(user: user).first]
      end
  end
end

task update_initial_ranking_day: :environment  do
  puts "UPDATE INITIAL RANKING DAY AT #{Time.now}"

  Team.all.each do |team|
    AnswerCreator::RankingUpdater.new(team).update_start_position_on_day
  end
end

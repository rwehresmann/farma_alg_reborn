task update_initial_ranking_day: :environment  do
  puts "update_initial_ranking_day called at #{Time.now}"
  Team.all.each do |team|
    AnswerCreator::RankingUpdater.new(team).update_start_position_on_day
  end
end

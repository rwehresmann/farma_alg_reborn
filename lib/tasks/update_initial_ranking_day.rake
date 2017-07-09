task :update_initial_ranking_day do
  Team.all.each { |team| RankingUpdater.new(team).update_start_position_on_day }
end

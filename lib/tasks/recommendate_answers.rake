task recommendate_answers: :environment do
  Team.all.each { |team| Recommendator.new(team).search_and_create_recommendations }
end

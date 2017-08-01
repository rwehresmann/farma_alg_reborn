task recommendate_answers: :environment do
  Team.all.each do |team|
    p "RECOMMENDATION CALL"
    Recommendator.new(team).search_and_create_recommendations
    p team
  end
end

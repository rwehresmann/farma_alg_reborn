task recommendate_answers: :environment do
  Team.all.each do |team|
    puts "RECOMMENDATION CALLED AT #{Time.now}"
    Recommendator.new(team).search_and_create_recommendations
  end
end

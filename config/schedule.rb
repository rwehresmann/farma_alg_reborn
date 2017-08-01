ENV.each { |k, v| env(k, v) }

set :output, "log/whenever.log"

every 1.minute do #3.hours do
  rake "recommendate_answers"
end

every 1.minute do #:day, at: "12pm" do
  rake "update_initial_ranking_day"
end

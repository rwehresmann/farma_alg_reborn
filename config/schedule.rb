set :output, 'log/whenever.log'

every 2.hours do
  runner "ComputeUserSimilarityJob.perform_later"
end

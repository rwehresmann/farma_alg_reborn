set :output, 'log/whenever.log'

every 2.hours do
  runner "ComputeUsersSimilarityJob.perform_later"
end

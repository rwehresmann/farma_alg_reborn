ENV.each { |k, v| env(k, v) }

set :output, 'log/whenever.log'

every 1.minute do
  rake "recommendate_answers"
end

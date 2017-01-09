User.find_or_create_by!(name: "Indiana Jones", teacher: true, email: "indiana@mail.com") do |user|
  user.password = "foobar"
end

User.find_or_create_by!(name: "Emmett Brown", teacher: true, email: "emmet@mail.com") do |user|
  user.password = "foobar"
end

User.find_or_create_by!(name: "Marty McFly", teacher: false, email: "marty@mail.com") do |user|
  user.password = "foobar"
end

# Create teams.
User.where(teacher: true).each do |user|
  3.times do |i|
    user.teams_created.find_or_create_by(name: "Team #{i} from #{user.name}") do |team|
      team.password = "foobar"
    end
  end
end

# Create exercises.
User.all.each do |user|
  2.times do |i|
    user.exercises.find_or_create_by!(title: "Exercise_#{i}",
                                      description: "# Description of exercise_#{i}")
  end
end

# Create questions.
Exercise.all.each do |exercise|
  4.times do |i|
    exercise.questions.find_or_create_by!(description: "Question #{i} from exercise #{exercise.title}")
  end
end

# Create test cases.
Question.all.each do |question|
  2.times do |i|
    question.test_cases.find_or_create_by!(title: "Test case #{i}",
                                           output: "Hello, world.\n")
  end
end

User.find_or_create_by!(name: "Indiana Jones", teacher: true, email: "indiana@mail.com") do |user|
  user.password = "foobar"
end

User.find_or_create_by!(name: "Emmett Brown", teacher: true, email: "emmet@mail.com") do |user|
  user.password = "foobar"
end

User.find_or_create_by!(name: "Marty McFly", teacher: false, email: "marty@mail.com") do |user|
  user.password = "foobar"
end

User.find_or_create_by!(name: "Genji", teacher: false, email: "genji@mail.com") do |user|
  user.password = "foobar"
end

User.find_or_create_by!(name: "Hanzo", teacher: false, email: "hanzo@mail.com") do |user|
  user.password = "foobar"
end

User.find_or_create_by!(name: "Roadhog", teacher: false, email: "roadhog@mail.com") do |user|
  user.password = "foobar"
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
    exercise.questions.find_or_create_by!(title: "Question #{i}",
                                          description: "Question #{i} from exercise #{exercise.title}",
                                          score: 10, operation: "task")
  end
end

# Create test cases.
Question.all.each do |question|
  2.times do |i|
    question.test_cases.find_or_create_by!(title: "Test case #{i}",
                                           output: "Hello, world.\n")
  end
end

# Create teams.
User.where(teacher: true).each do |user|
  3.times do |i|
    user.teams_created.find_or_create_by(name: "Team #{i} from #{user.name}") do |team|
      team.password = "foobar"
    end
  end
end

# Add exercises to teams
Team.all.each do |team|
  exercise = Exercise.find(rand(0...Exercise.count))
  team.exercises << exercise if !team.exercises.include?(exercise)
end

# Add users to teams and create some user scores.
User.where(teacher: false).each do |user|
  Team.all.each do |team|
    unless team.enrolled?(user)
      team.enroll(user)
      UserScore.where(user: user, team: team).update(score: rand(1..100))
    end
  end
end

User.all.each do |user|
  user.teams.each do |team|
    team.exercises.each do |exercise|
      exercise.questions.each do |question|
        correct = [true, false].sample
        answer = FactoryGirl.create(:answer, question: question, team: team,
                           user: user, correct: correct)
        question.test_cases.each do |test_case|
          FactoryGirl.create(:answer_test_case_result, answer: answer, test_case: test_case,
                                  output: answer.compiler_output)
        end
      end
    end
  end
end


# Create answer connections.
Answer.all.each do |answer|
  AnswerConnection.create!(answer_1: answer,
                                      answer_2: Answer.find(rand(1..Answer.count)),
                                      similarity: rand(1..100))
end

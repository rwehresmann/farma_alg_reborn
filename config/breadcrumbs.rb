## Exercise crumbs ##

crumb :exercises do
  link "Exercícios", exercises_path
end

crumb :exercise do |exercise|
  link exercise.title, exercise
  parent :exercises
end

crumb :new_exercise do
  link "Novo", new_exercise_path
  parent :exercises
end

crumb :edit_exercise do |exercise|
  link "Editar", edit_exercise_path(exercise)
  parent :exercise, exercise
end

## Question crumbs ##

crumb :questions do |exercise|
  link "Questões", exercise_questions_path(exercise)
  parent :exercise, exercise
end

crumb :question do |question|
  link question.title, question
  parent :questions, question.exercise
end

crumb :new_question do |exercise|
  link "Novo", new_exercise_question_path(exercise)
  parent :questions, exercise
end

crumb :edit_question do |question|
  link "Editar", edit_question_path(question)
  parent :question, question
end

## Test case crumbs ##

crumb :test_cases do |question|
  link "Casos de teste", question_test_cases_path(question)
  parent :question, question
end

crumb :test_case do |test_case|
  link test_case.title, test_case
  parent :test_cases, test_case.question
end

crumb :new_test_case do |question|
  link "Novo", new_question_test_case_path(question)
  parent :test_cases, question
end

crumb :edit_test_case do |test_case|
  link "Editar", edit_test_case_path(test_case)
  parent :test_case, test_case
end

## TEAM crumbs ##

crumb :teams do
  link "Turmas", teams_path
end

crumb :team do |team|
  link team.name, team
  parent :teams
end

crumb :new_team do
  link "Novo", new_team_path
  parent :teams
end

crumb :edit_team do |team|
  link "Editar", edit_team_path(team)
  parent :team, team
end

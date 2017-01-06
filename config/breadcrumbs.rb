## Exercise crumbs ##

crumb :exercises do
  link "Exercícios", exercises_path
end

crumb :exercise do |exercise|
  link "Exercício", exercise
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
  link "Questão", question
  parent :questions, question.exercise
end

crumb :new_question do |exercise|
  link "Novo", new_exercise_question_path
  parent :questions, exercise
end

crumb :edit_question do |question|
  link "Editar", edit_question_path(question)
  parent :question, question
end

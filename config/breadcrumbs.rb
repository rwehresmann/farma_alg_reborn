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

Rails.application.routes.draw do
  resources :learning_objects

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

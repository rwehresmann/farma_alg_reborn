Rails.application.routes.draw do
  resources :learning_objects
  resources :exercises

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

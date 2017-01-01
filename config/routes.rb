Rails.application.routes.draw do
  resources :exercises

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

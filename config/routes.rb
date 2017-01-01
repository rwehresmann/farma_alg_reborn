Rails.application.routes.draw do
  resources :exercises do
    resources :questions
  end

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

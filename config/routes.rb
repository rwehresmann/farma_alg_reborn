Rails.application.routes.draw do
  resources :exercises, shallow: true do
    resources :questions do
      resources :test_cases
    end
  end

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

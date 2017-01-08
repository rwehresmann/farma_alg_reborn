Rails.application.routes.draw do
  resources :exercises, shallow: true do
    resources :questions do
      resources :test_cases do
        member do
          post :test
        end

        collection do
          post :test_all
        end
      end
    end
  end

  # resources :users, only: [:index, :show]
  resources :teams

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

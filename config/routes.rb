Rails.application.routes.draw do
  resources :exercises, shallow: true do
    resources :questions do
      resources :test_cases do
        member do
          post :run
        end

        collection do
          post :run_all
        end
      end
    end
  end

  # post 'run_all/:question_id', to: 'test_cases#run_all', as: 'run_all'

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

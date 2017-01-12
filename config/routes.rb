Rails.application.routes.draw do
  resources :exercises, shallow: true do
    member do
      get :list
    end

    resources :questions do
      member do
        get :answer
      end

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
  resources :teams do
    member do
      post :enroll
      post :unenroll
    end
  end

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

Rails.application.routes.draw do
  resources :exercises, shallow: true do
    resources :questions do
      member do
        resources :answers, only: [:new, :create]
        post :test_answer
      end

      resources :test_cases
    end
  end

  # resources :users, only: [:index, :show]
  resources :teams do
    member do
      post :enroll
      post :unenroll
      get :search_answers
      get 'list_questions/:exercise_id', to: 'teams#list_questions', as: 'list_exercise_questions'
    end

    get :connections, on: :collection
  end

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

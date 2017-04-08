Rails.application.routes.draw do
  scope :answers, as: :answers do
    get :connections, to: 'answers#connections'
  end

  resources :exercises, shallow: true do
    resources :questions do
      member do
        resources :answers, only: [:new, :create, :show], shallow: true do
          resources :comments, only: [:create, :destroy, :update]
        end
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
      get 'list_questions/:exercise_id', to: 'teams#list_questions', as: 'list_exercise_questions'
      get :answers
    end
  end

  resources :answer_connections, only: [:show, :destroy]

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

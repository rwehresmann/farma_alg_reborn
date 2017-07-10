Rails.application.routes.draw do
  scope :answers, as: :answers do
    get :connections, to: 'answers#connections'
    post :log, to: 'answers#log'
  end

  resources :answers, only: [:index]
  get 'answers/:id/show_as_raw', to: 'answers#show_as_raw', as: :answer_as_raw

  resources :exercises, shallow: true do
    resources :questions do
      member do
        resources :answers, only: [:create, :show]

        get 'team/:team_id/answers', to: 'answers#new', as: :new_answer
        post :test_answer
      end

      resources :test_cases
    end
  end

  resources :teams, except: [:show] do
    member do
      get :rankings
      get :exercises
      get :users
      get :graph
      post :enroll
      post :unenroll
      post 'add_or_remove_exercise/:exercise_id', to: 'teams#add_or_remove_exercise', as: :add_or_remove_exercise
      get 'list_questions/:exercise_id', to: 'teams#list_questions', as: 'list_exercise_questions'
      get :answers
    end
  end

  resources :answer_connections, only: [:show, :destroy]

  resources :messages, only: [:index, :new, :create, :show]

  resources :recommendations, only: [:index, :show]

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

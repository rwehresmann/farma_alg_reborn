Rails.application.routes.draw do
  resources :exercises, shallow: true do
    resources :questions do
      member do
        resources :answers, only: [:new, :create, :show]
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

  scope :graph, as: :graph do
    get    :search_answers,     to: 'graph#search_answers'
    get    :connections,        to: 'graph#connections'
    get    :connection,         to: 'graph#connection'
    get    :answer,             to: 'graph#answer'
    delete :destroy_connection, to: 'graph#destroy_connection'
  end

  devise_for :users
  get 'dashboard/home'
  root to: 'dashboard#home'
end

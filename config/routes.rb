Rails.application.routes.draw do
	def default_routes
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
	      get :stats
	      post :enroll
	      post :unenroll
	      get 'list_questions/:exercise_id', to: 'teams#list_questions', as: 'list_exercise_questions'
	      get :answers
	    end
	  end

	  resources :answer_connections, only: [:show, :destroy]

	  resources :messages, only: [:index, :new, :create, :show]

	  resources :recommendations, only: [:index, :show]

	  resources :team_exercises, only: [:create, :update, :destroy]

		devise_for :users, :controllers => { :registrations => :registrations }

	  get 'dashboard/home'
	  root to: 'dashboard#home'
	end

	if ENV.has_key?('RAILS_RELATIVE_URL_ROOT')
		scope ENV['RAILS_RELATIVE_URL_ROOT'] do
			default_routes
		end
	else
		default_routes
	end
end

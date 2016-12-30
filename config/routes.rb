Rails.application.routes.draw do
  get 'dashboard/home'
  root to: 'dashboard#home'
end

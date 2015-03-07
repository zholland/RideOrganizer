Rails.application.routes.draw do
  devise_for :users

  get 'pages_output/index'

  root 'pages#home'
  get 'pages/home'
  get 'pages/about'
  get 'trip_plans/planner_output'
  post 'trip_plans/get_travellers'


  resources :trip_plans do
    member do
      post :get_travellers
    end
  end
end

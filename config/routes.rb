Rails.application.routes.draw do
  devise_for :users

  root 'pages#home'
  get 'pages/home'
  get 'pages/about'
  get 'trip_plans/planner_output'
  get 'trip_plans/choose'
  get 'trip_plans/new'
  get 'trip_plans/edit'
  post 'trip_plans/get_travellers'


  resources :trip_plans do
    member do
      post :get_travellers
    end
  end
end

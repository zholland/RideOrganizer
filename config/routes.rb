Rails.application.routes.draw do
  devise_for :users

  root 'pages#home'
  get 'pages/home'
  get 'pages/about'
  # get 'trip_plans/:id/planner_output/', to: 'trip_plans#planner_output(:id)', as: 'planner_output'
  get 'trip_plans/choose'
  get 'trip_plans/new'
  get 'trip_plans/guest_edit', to: 'trip_plans#guest_edit'
  get 'trip_plans/guest_planner_output', to: 'trip_plans#guest_planner_output'
  post 'trip_plans/:id/get_travellers', to: 'trip_plans#get_travellers', as: 'get_travellers'
  post 'trip_plans/get_travellers', to: 'trip_plans#get_travellers', as: 'guest_get_travellers'
  patch 'trip_plans/guest_update', to: 'trip_plans#guest_update'


  resources :trip_plans do
    member do
      get :planner_output
      post :get_travellers
    end
  end
end

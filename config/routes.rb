Rails.application.routes.draw do
  devise_for :users

  root 'pages#home'
  get 'pages/home'
  get 'pages/about'
  get 'pages/help'
  get 'trip_plans/choose'
  get 'trip_plans/new'
  get 'trip_plans/guest_edit', to: 'trip_plans#guest_edit'
  get 'trip_plans/guest_planner_output', to: 'trip_plans#guest_planner_output'
  post 'trip_plans/:id/get_travellers', to: 'trip_plans#get_travellers', as: 'get_travellers'
  post 'trip_plans/get_travellers', to: 'trip_plans#get_travellers', as: 'guest_get_travellers'
  patch 'trip_plans/guest_update', to: 'trip_plans#guest_update'
  post 'trip_plans/load_csv', to: 'trip_plans#load_csv', as: 'load_csv'
  post 'trip_plans/new', to: 'trip_plans#new'
  delete 'trip_plans/destroy_traveller/:traveller_id', to: 'trip_plans#destroy_traveller'
  delete 'trip_plans/:id/destroy_traveller/:traveller_id', to: 'trip_plans#destroy_traveller'
  post 'trip_plans/new_driver', to: 'trip_plans#new_driver'
  post 'trip_plans/:id/new_driver', to: 'trip_plans#new_driver'
  post 'trip_plans/new_passenger', to: 'trip_plans#new_passenger'
  post 'trip_plans/:id/new_passenger', to: 'trip_plans#new_passenger'
  post 'trip_plans/edit_name', to: 'trip_plans#edit_name'
  post 'trip_plans/:id/edit_name', to: 'trip_plans#edit_name'
  post 'trip_plans/edit_email', to: 'trip_plans#edit_email'
  post 'trip_plans/:id/edit_email', to: 'trip_plans#edit_email'
  post 'trip_plans/edit_address', to: 'trip_plans#edit_address'
  post 'trip_plans/:id/edit_address', to: 'trip_plans#edit_address'
  post 'trip_plans/edit_number_of_passengers', to: 'trip_plans#edit_number_of_passengers'
  post 'trip_plans/:id/edit_number_of_passengers', to: 'trip_plans#edit_number_of_passengers'
  post 'trip_plans/:id/edit', to: 'trip_plans#edit'
  post 'trip_plans/guest_edit', to: 'trip_plans#guest_edit'
  post 'trip_plans/:id/notify_travellers', to: 'trip_plans#notify_travellers'
  post 'trip_plans/notify_travellers', to: 'trip_plans#notify_travellers'


  resources :trip_plans do
    member do
      get :planner_output
      post :get_travellers
    end
  end
end

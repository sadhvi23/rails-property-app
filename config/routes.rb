Rails.application.routes.draw do
  # properties routes
  get '/properties', to: 'properties#index'
  post '/properties', to: 'properties#create'
  get '/properties/me', to: 'properties#my_properties'
  get '/properties/:id', to: 'properties#show'
  put '/properties/:id', to: 'properties#update'
  delete '/properties/:id', to: 'properties#destroy'
  put '/properties/:id/approval_status', to: 'properties#update_approval_status'
  put '/properties/:id/availability', to: 'properties#update_availability'
  put '/properties/:id/deactivate', to: 'properties#deactivate_activate'


  # users routes
  resources :users
  post '/users/signup', to: 'users#signup'
  post '/users/login', to: 'users#login'
  put '/users/:id/logout', to: 'users#logout'
  put '/users/:id/deactivate', to: 'users#deactivate_activate'
end

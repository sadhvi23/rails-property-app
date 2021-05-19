Rails.application.routes.draw do
  # properties routes
  get '/properties', to: 'properties#index'
  post '/properties', to: 'properties#create'
  get '/properties/:id', to: 'properties#show'
  put '/properties/:id', to: 'properties#update'
  delete '/properties/:id', to: 'properties#destroy'
  post '/properties/:id/add_owner', to: 'properties#add_owner'
  resources :users
  post '/users/signup', to: 'users#signup'
  post '/users/login', to: 'users#login'
  post '/users/:id/logout', to: 'users#logout'
end

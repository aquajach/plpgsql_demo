Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/users', to: 'users#index'
  get '/user', to: 'users#show'
  post '/users', to: 'users#create'
end

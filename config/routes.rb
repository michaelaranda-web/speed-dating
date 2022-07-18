Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"
  
  post 'upload', to: 'welcome#upload'
  get 'assignments', to: 'assignments#index'
  get 'assignments/:id', to: 'assignments#show'
end

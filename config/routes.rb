Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"
  
  post 'upload', to: 'welcome#upload'
  
  resources :assignments
  
  resources :icebreaker_questions
  post 'upload_icebreaker_questions', to: 'icebreaker_questions#upload'
end

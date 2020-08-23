Rails.application.routes.draw do
  resources :notes
  resource :users, only: [:create] #Special create route
  post "/login", to: "users#login" #Points to the /login endpoint. We need to create a functional in controller called login
  get "/auto_login", to: "users#auto_login"
end

# resource - creates all the restful routes for the model in question, however you can specify which route by using the
# only keyword

# format of routes is
# <type of request (get, post, etc)> "/endpoint", to: "controller-for-specific-model-name#function-name-in-controller"
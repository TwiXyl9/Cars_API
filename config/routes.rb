Rails.application.routes.draw do
   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
   mount_devise_token_auth_for 'User', at: 'authentication'

   # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :brands do
        resources :models
      end
    end
  end
end

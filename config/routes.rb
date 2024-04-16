Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users do
    resources :transactions
    resources :rewards do
      member do
        post 'claim'
      end
    end
  end

  # Defines the root path route ("/")
  root "users#index"
end

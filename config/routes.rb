Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :destroy] do
      # Adding the report route for comments
      post :report, on: :member  # This will map to /posts/:post_id/comments/:id/report
    end
    resources :likes, only: [:create, :destroy]
  end

  devise_for :users
  resources :users, only: [] do
    member do
      post :report
      delete 'cancel_account', to: 'users#destroy', as: :cancel_account
      get :posts, to: 'users#posts', as: :posts
    end
  end

  # Add route for reporting comments separately (in case you want it outside of posts)
  resources :comments, only: [] do
    member do
      post :report  # This will map to /comments/:id/report
    end
  end

  # Define other routes
  root "posts#index"
  get "home/about"

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Other routes like PWA can be added here if needed

end

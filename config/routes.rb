Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :books, only: [:index, :show]
  resources :topics, only: [:index, :show]
  resources :book_transactions, only: [:index, :show, :update, :new, :create] do
    collection do
      get :active
      get :archived
    end
    member do
      get :return_book
    end
  end
  resources :borrowers, only: [:index, :show]

end

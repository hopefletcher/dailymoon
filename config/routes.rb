Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'calendar#day'
  get 'home', to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :moods, only: [:new, :create, :edit, :show, :update, ]
  resources :events, only: [:new, :create]
  get 'stats', to: 'pages#stats'
  get 'month', to: 'calendar#month'
  get 'day', to: 'calendar#day'
end

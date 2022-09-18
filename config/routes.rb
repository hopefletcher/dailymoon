Rails.application.routes.draw do
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'calendar#day'
  get 'home', to: 'pages#home'

  resource :mood, only: [:new, :create, :edit, :show, :update]
  # resolve('Mood') { [:mood] }

  resources :events, only: [:index, :new, :create, :edit, :update, :destroy]

  get 'stats', to: 'pages#stats'
  get 'month', to: 'calendar#month'
  get 'day', to: 'calendar#day'
end

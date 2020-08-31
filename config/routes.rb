Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root to: 'application#index'
  resources :stories
  resources :articles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

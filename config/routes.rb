Joblr::Application.routes.draw do

  get "users/show"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :authentifications, only: [:index, :destroy]

  root :to => 'pages#home'
end

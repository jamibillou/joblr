Joblr::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users
  resources :authentifications, only: [:index, :destroy]

  root :to => 'pages#home'
end

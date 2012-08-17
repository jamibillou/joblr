require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'authentifications', registrations: 'registrations' }

  resources :authentifications, only: [:index, :destroy]
  resources :sharings
  resources :beta_invites,      only: [:new, :create, :edit, :update]
  resources :users do
    resources :profiles
  end

  get  'users/auth/failure'  => 'authentifications#failure'
  post 'users/share_profile' => 'users#share_profile'

  match 'home',              to: 'pages#home'
  match 'sharings/linkedin', to: 'sharings#linkedin'

  # Subdomain constraints
  match '', to: 'users#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' && r.path == '/' }

  root to: 'pages#home', constraints: SignedIn.new(false)
  root to: 'users#edit', constraints: SignedIn.new(true) && SignedUp.new(false)
  root to: 'users#show', constraints: SignedIn.new(true) && SignedUp.new(true)
end
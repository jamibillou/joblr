require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  # Error pages
  match '/404', to: 'errors#error_404'
  match '/500', to: 'errors#error_500'

  devise_for :users, controllers: {omniauth_callbacks: 'authentifications', registrations: 'registrations', sessions: 'sessions'}

  resources :authentifications, only: [:index, :destroy]
  resources :sharings,          only: [:new, :create]
  resources :beta_invites
  resources :users do
    resources :profiles
  end

  get  'users/auth/failure'  => 'authentifications#failure'
  post 'users/share_profile' => 'users#share_profile'

  match 'home',              to: 'pages#home'
  match 'style_tile',        to: 'pages#style_tile'
  match 'sharings/linkedin', to: 'sharings#linkedin'

  # Subdomain constraints
  match '', to: 'users#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' && r.path == '/' }

  # Dynamic root_path
  root to: 'pages#home', constraints: SignedIn.new(false)
  root to: 'users#edit', constraints: SignedIn.new(true) && SignedUp.new(false)
  root to: 'users#show', constraints: SignedIn.new(true) && SignedUp.new(true)
end
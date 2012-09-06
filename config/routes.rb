require File.expand_path('../../lib/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  # Error pages
  match '/404', to: 'errors#error_404'
  match '/500', to: 'errors#error_500'

  devise_for :users, controllers: {omniauth_callbacks: 'authentifications', registrations: 'registrations'}

  resources :authentifications, only: [:destroy]
  resources :sharings,          only: [:new, :create]
  resources :email_sharings,    only: [:new, :create]
  resources :beta_invites, except: :index do
    get :thank_you
    get :send_code
  end
  resources :users do
    resources :profiles
  end

  get  'users/auth/failure'  => 'authentifications#failure'
  post 'users/share_profile' => 'users#share_profile'

  match 'landing',                to: 'pages#landing'
  match 'admin',                  to: 'pages#admin'
  match 'style_tile',             to: 'pages#style_tile'
  match 'sharings/linkedin',      to: 'sharings#linkedin'

  # Subdomain constraints
  match '', to: 'users#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' && r.path == '/' }

  # Dynamic root_path
  root to: 'pages#landing', constraints: SignedIn.new(false)
  root to: 'users#edit',    constraints: SignedIn.new(true) && SignedUp.new(false)
  root to: 'users#show',    constraints: SignedIn.new(true) && SignedUp.new(true)
end
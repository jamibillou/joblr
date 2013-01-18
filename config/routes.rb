require File.expand_path('../../lib/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  # Error pages
  match '/404', to: 'errors#error_404'
  match '/422', to: 'errors#error_422'
  match '/500', to: 'errors#error_500'

  devise_for :users, controllers: {omniauth_callbacks: 'authentications', registrations: 'registrations'}

  resources :invite_emails, except: :index do
    get :thank_you
    get :send_code
  end
  resources :authentications, only: [:destroy]
  resources :users do
    resources :profiles
  end
  resources :profile_emails, only: [:create, :index] do
    get :already_answered
    get :decline
  end
  resources :feedback_emails

  get  'users/auth/failure'  => 'authentications#failure'
  post 'users/share_profile' => 'users#share_profile'

  match 'home',       to: 'pages#landing'
  match 'admin',      to: 'pages#admin'
  match 'style_tile', to: 'pages#style_tile'
  match 'close',      to: 'pages#close'

  # Subdomain constraints
  match '', to: 'users#show', constraints: Subdomain.new(true) || MultiLevelSubdomain.new(true)

  # Dynamic root_path
  root to: 'pages#landing', constraints: SignedIn.new(false)
  root to: 'users#edit',    constraints: SignedIn.new(true) && SignedUp.new(false)
  root to: 'users#show',    constraints: SignedIn.new(true) && SignedUp.new(true)

  # Preview of emails
  if Rails.env.development?
    mount InviteEmailMailer::Preview   => 'invite_email_mailer'
    mount ProfileEmailMailer::Preview  => 'profile_email_mailer'
    mount FeedbackEmailMailer::Preview => 'feedback_email_mailer'
  end

  # Kludge to preserve compatibility with deprecated BetaInvite model
  get 'beta_invites/(:id)/edit' => 'invite_emails#edit'
end

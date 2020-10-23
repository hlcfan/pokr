Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  require 'sidekiq/web'

  post 'home/feedback'
  get 'home/sign_up_form'
  get 'about', to: 'site#about'
  get 'faq', to: 'site#faq'
  get 'donate', to: 'site#donate'
  get 'apps', to: 'site#apps'
  get 'extensions', to: 'site#extensions'
  get 'pricing', to: 'site#pricing_page'

  mount ActionCable.server => '/cable'

  admin_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints admin_constraint do
    mount Logster::Web => "/logs"
    mount Sidekiq::Web => '/sidekiq'
    get 'marketing/send_email'
    post 'marketing/send_email'
  end

  resources :rooms do
    member do
      get :story_list
      get :user_list
      post :set_room_status
      get :draw_board
      post :switch_role
      get :summary
      post :invite
      get :screen
      post :screen
      post :sync_status
      post :leaflet_submit
      get :view, to: 'rooms#leaflet_view'
      post :leaflet_finalize_point
    end
  end

  resources :schemes
  resources :teams

  namespace :users do
    get :autocomplete
  end

  get 'profile' => 'profile#show'
  get 'profile/edit' => 'profile#edit'
  patch 'profile/update' => 'profile#update'
  patch 'profile/update_password' => 'profile#update_password'
  resources :dashboard, only: [:index] do
    collection do
      get :room_list
    end
  end

  resources :posts, only: [:show, :index]

  post 'payments/hook'
  get 'billing' => 'billing#show'

  get 'typeahead' => 'typeahead#index'

  match "/404" => "errors#not_found", via: [ :get, :post, :patch, :delete ], as: :not_found

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :rooms
      resources :schemes, only: [:index]
    end
  end

  root 'home#index'
end

Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup


  post 'home/feedback'
  get 'home/sign_up_form'
  get 'about', to: 'site#about'
  get 'faq', to: 'site#faq'

  mount ActionCable.server => '/cable'

  admin_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints admin_constraint do
    mount Logster::Web => "/logs"
  end

  resources :rooms do
    member do
      get :story_list
      get :user_list
      post :set_room_status
      get :draw_board
      post :switch_role
    end
  end

  namespace :users do
    get :autocomplete
  end

  get 'profile' => 'profile#show'
  get 'profile/edit' => 'profile#edit'
  patch 'profile/update' => 'profile#update'
  patch 'profile/update_password' => 'profile#update_password'
  resources :dashboard, only: [:index]

  match "/404" => "errors#not_found", via: [ :get, :post, :patch, :delete ]

  root 'home#index'
end

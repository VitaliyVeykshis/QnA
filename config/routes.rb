require 'sidekiq/web'

Rails.application.routes.draw do
  # authenticate :user, lambda { |u| u.admin? } do
  mount Sidekiq::Web => '/sidekiq'
  # end

  use_doorkeeper do
    controllers applications: 'oauth/applications'
  end

  mount ActionCable.server => '/cable'
  devise_for :users,
             controllers: {
               registrations: 'registrations',
               omniauth_callbacks: 'omniauth_callbacks'
             }

  devise_scope :user do
    get 'registrations/new_oauth_sign_up',
        to: 'registrations#new_oauth_sign_up',
        as: 'new_oauth_sign_up'
    patch 'registrations/create_oauth_sign_up',
          to: 'registrations#create_oauth_sign_up',
          as: 'create_oauth_sign_up'
  end

  root to: 'questions#index'
  get 'badges/index'
  get 'search', to: 'search#search', as: 'search'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: %i[create], shallow: true
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, only: %i[create update destroy], concerns: %i[votable commentable] do
      patch :accept, on: :member
    end

    resources :subscriptions, only: %i[create destroy]
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy], shallow: true do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end
end

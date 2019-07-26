Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'questions#index'
  get 'badges/index'

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
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy
end

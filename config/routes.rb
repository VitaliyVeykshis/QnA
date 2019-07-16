Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  get 'badges/index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: %i[votable], shallow: true do
    resources :answers, only: %i[create update destroy], concerns: %i[votable] do
      patch :accept, on: :member
    end
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy
end

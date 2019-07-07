Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers, only: %i[create update destroy] do
      patch :accept, on: :member
    end
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end
end

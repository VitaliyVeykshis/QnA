Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers, only: %i[create update destroy] do
      patch :accept, on: :member
    end
  end
end

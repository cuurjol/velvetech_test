Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'students#index'
    end

    unauthenticated do
      root 'devise/sessions#new'
    end
  end

  resources :users, except: %i[index new create destroy]
  resources :students do
    collection { post :search, to: 'students#index' }
  end
end

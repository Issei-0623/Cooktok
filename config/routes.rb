Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  get 'proxy_video', to: 'searches#proxy_video'
  root to: "home#index"

  resource :mypage, controller: :mypages, only: [:show] do
    patch :avatar_update, on: :collection
    delete :avatar_destroy, on: :collection
  end


  resources :folders, only: [:index, :create, :edit, :update, :destroy, :show]
  resources :searches, only: [:index]

  resources :saved_videos, only: [:index, :create, :destroy, :update] do
    member do
      post :remove_from_folder
    end
  end
end

Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "home#index"

  resource :mypage, controller: :mypages, only: [:show, :edit, :update] do
    patch :avatar_update, on: :collection
    delete :avatar_destroy, on: :collection
  end


end

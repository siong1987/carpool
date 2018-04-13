Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  delete "/logout", to: "session#destroy"

  resources :session, only: [:index]
  resource :info, only: [:show, :update]
  resources :cities, only: [:index]
  resources :carpools, only: [:new, :create, :edit, :update, :destroy] do
    put :full
    get :search, on: :collection
  end
end

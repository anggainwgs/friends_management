Rails.application.routes.draw do

  root "accounts#landing"

  resources :accounts do
    collection do
      post :connect
      get  :common_friends
      post :add_subscribe
      post :block_subscribe
      post :add_update
      get  :landing
    end
  end
end

Rails.application.routes.draw do
  resources :accounts do
    collection do
      post :connect
      get  :common_friends
      post :add_subscribe
      post :block_subscribe
      post :status
    end
  end
end

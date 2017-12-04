Rails.application.routes.draw do
  resources :accounts do
    collection do
      post :connect
    end
  end
end

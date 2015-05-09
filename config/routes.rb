Rails.application.routes.draw do
  get "/about", to: "pages#about"

  resources :characters do
    resources :comments, only: [:create]
  end

  root "characters#index"
end

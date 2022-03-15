Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/users", to: "users#create"
    resources :account_activations, only: :edit
    resources :products, only: :show
  end
end

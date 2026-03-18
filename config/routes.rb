Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  get "up" => "rails/health#show", as: :rails_health_check

  post "auth/register", to: "auth#register"
  post "auth/login",    to: "auth#login"

  namespace :api do
    namespace :v1 do
      resources :restaurants do
        resources :menu_items
      end
    end
  end
end

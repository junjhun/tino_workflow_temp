Rails.application.routes.draw do
  resources :calendars
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

# Defines the root path route ("/")
   root to:'admin/dashboard#index'

  namespace :reports do
    resources :orders, only: :show
  end
end

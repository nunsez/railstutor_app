Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  root 'static_pages#home'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  get 'help', to: 'static_pages#help'
  get 'signup', to: 'users#new'

  resources :users, except: %i[new], concerns: :paginatable
  resources :account_activations, only: :edit
  resources :password_resets, only: %i[new create edit update], param: :token
  resources :microposts, only: %i[create destroy]
end

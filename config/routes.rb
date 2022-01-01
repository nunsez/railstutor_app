Rails.application.routes.draw do
  concern :paginatable do
    get '(:page)', action: :index, on: :collection, as: ''
  end

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  get 'help', to: 'static_pages#help'
  get 'signup', to: 'users#new'

  resources :users, except: %w[new], concerns: :paginatable

  root 'static_pages#home'
end

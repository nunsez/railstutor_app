Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  root 'static_pages#home'

  get 'signup', to: 'users#new'

  scope module: :sessions do
    get 'login', action: :new
    post 'login', action: :create
    delete 'logout', action: :destroy
  end

  scope module: :static_pages do
    get '(posts/:page)', action: :home, as: :home
    get 'about'
    get 'contact'
    get 'help'
  end

  resources :users, except: %i[new], concerns: :paginatable do
    member do
      get :following, :followers
      get '(posts/:page)', action: :show
    end
  end

  resources :account_activations, only: :edit
  resources :password_resets, only: %i[new create edit update], param: :token
  resources :microposts, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end

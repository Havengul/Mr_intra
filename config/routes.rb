Rails.application.routes.draw do
  get 'pages/home'
  root 'pages#home'
  get 'pages/test'
  get 'pages/shower' => 'starter#shower'
  #root 'starter#shower'
  resources :pages do
    collection do
      get :shower
    end
  end
end

Rails.application.routes.draw do
  get 'pages/home'
  root 'pages#home'
  get 'pages/shower' => 'pages#shower'
  get 'pages/allusers' => 'pages#allusers'
#  resources :pages do
#    collection do
#      get :shower
#    end
#  end
end

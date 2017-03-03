Rails.application.routes.draw do
  get 'pages/home'
  root 'pages#home'
  get 'pages/shower' => 'pages#shower'
  get 'pages/allusers' => 'pages#allusers'
  get 'pages/refreshusers' => 'pages#refreshusers'
#  resources :pages do
#    collection do
#      get :shower
#    end
#  end
end

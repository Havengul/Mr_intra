Rails.application.routes.draw do
  get 'starter/shower'

  root 'starter#shower'
end

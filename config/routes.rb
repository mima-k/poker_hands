Rails.application.routes.draw do
  root 'hands#index'
  post '/', to: 'hands#index'
end

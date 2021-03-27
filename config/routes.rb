Rails.application.routes.draw do
  root 'hands#index'
  post '/hands#index', to: 'hands#index'
end

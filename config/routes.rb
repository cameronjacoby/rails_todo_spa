Rails.application.routes.draw do
  resources :to_dos, except: [:new, :edit]
  match '*path', to: 'to_dos#index', via: 'get'
  root 'to_dos#index'
end
Rails.application.routes.draw do
  
  get 'top/show'
  root 'employee/items#index'
#####################植松エリア##################################################################################
  namespace :employee do
    resources :items
    resources :item_image, only:[:show]
    resources :processings, only:[:new, :create, :destroy]
    resources :products, except:[:show, :edit, :update]
    resources :products_change, only:[:index]
  end
#####################菅野さんエリア##################################################################################
  namespace :customer do
    resources :users
  end
  
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end

Rails.application.routes.draw do

  namespace :admin do
    get '/' => 'dashboard#index'
    resources :traffic_logs do
      member do
        get 'logs'
      end
    end
    resources :users do
      collection do
        get 'couponused'
        get 'comment_users'
        get 'before_users'
      end
      member do
        get 'logs'
      end
    end
    resources :coupons do
      member do
        get 'send_message'
      end
    end
    resources :viral_actions
  end

  namespace :fb do
    post 'create' => 'home#create'
    get 'index' => 'home#index'
    resources :users
  end

  namespace :pc do
    get 'index' => 'home#index'
    get 'test' => 'home#test'
    get 'leaflet' => 'home#leaflet'
    resources :users, only: [:create]
    
  end

  namespace :mobile do
    get 'index' => 'home#index'
    get 'thanks' => 'home#thanks'
    get 'apply' => 'home#apply'
    get 'fail' => 'home#fail'
    get 'already' => 'home#already'
    get 'agree' => 'home#agree'
    get 'agree_brand' => 'home#agree_brand'
    get 'leaflet' => 'home#leaflet'
    get 'comment_thanks' => 'home#comment_thanks'
    get 'out_of_stock' => 'home#out_of_stock'
    get 'winners' => 'home#winners'
    resources :users do
      collection do
        get 'comment_new'
      end
    end
  end

  resources :addresses, only: [:index] 

  resources :viral_actions

  get 'web_switch' => 'web_switch#index'
  get 'fb_switch' => 'fb_switch#index'
  get 'current_time' => 'web_switch#current_time'
  get 'poster_stock' => 'web_switch#poster_stock'
  get 'survey' => 'web_switch#survey'
  get 'poster_user_list' => 'web_switch#poster_user_list'

  root 'web_switch#index'

  get 'event_open' => 'event#open'
  get 'event_finish' => 'event#finish'

  get "/:code", to:"coupons#show", contraints:{code: /[a-z]{5}-\d{4}/}, as: "coupon"
  get "/:code/edit", to:"coupons#edit", contraints:{code: /[a-z]{5}-\d{4}/}, as: "edit_coupon"
  put "/:code", to:"coupons#update", contraints:{code: /[a-z]{5}-\d{4}/}, as: "update_coupon"

  # resources :users
  devise_for :users
  resources :comments, except: [:update, :edit, :show] do
  end
  
end

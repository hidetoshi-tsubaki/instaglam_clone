Rails.application.routes.draw do

  root 'pages#top'
  get '/feed/:id',to:'pages#feed',as: 'feed'
  get '/all_posts/:id',to:'pages#all_posts',as: 'all_posts'

  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    unlocks: "users/unlocks"
  }  
  devise_scope :user do
    get '/users',to: 'users#index',as: 'users'
    get 'user/:id',to: 'users#show',as: 'user'
  end

  get '/post',to: 'posts#new'
  post '/posts',to: 'posts#create'
  get '/post/:id',to: 'posts#show',as: 'show_post'
  get '/post/:id',to: 'posts#edit'
  patch '/post',to: 'posts#update',as: 'update_post'
  delete '/post',to: 'posts#delete'
  post '/posts_search',to: 'posts#search'

  get '/bookmark/:id',to: 'bookmarks#add_bookmark',as: 'add_bookmark'
  get '/remove_bookmark/:id',to: 'bookmarks#remove_bookmark',as: 'remove_bookmark'
  
  get '/follow/:id',to: 'relationships#follow',as:'follow'
  get '/unfollow/:id',to: 'relationships#unfollow',as: 'unfollow'
  
  post '/comments',to:'comments#create'

  get '/notifications/:id',to:'notifications#index',as: 'notifications'
  get '/notifications_history/:id',to:'notifications#history',as: 'notifications_history'  
  get '/mail_notification/:id',to: 'notifications#mail_notification_toggle',as: 'mail_notification'
end

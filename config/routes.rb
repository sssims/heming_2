Rails.application.routes.draw do

  get  'users/login'
  get  'users/logout'

  post 'users/search'

  get  'users/login_attempt'
  post 'users/login_attempt'

  get  'users/new_follow'
  get  'users/unfollow'
  get  'users/follow_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get  'users/blurbs_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get  'users/users_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get  'users/edit_photo' 

  post 'users/upload_photo'

  get  'books/get_book'
  post 'books/get_book'

  get  'books/get_book_live'
  post 'books/get_book_live'

  get  'books/select_book'
  post 'books/select_book'

  get  'books/submit_book'
  post 'books/submit_book'

  get  'users/display_subpage'
  get  'users/own_show'
  post 'users/edit_about'

  get '/serve_image/:filename' => 'books#feed_image'
  get '/serve_user_photo/:filename' => 'users#feed_user_photo'

  resources :books
  resources :users
  resources :home
  
  root 'home#index'

end

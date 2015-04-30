Rails.application.routes.draw do

  root 'home#index'

  get 'home/change_page'

  get  'users/follow_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get  'users/blurbs_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get  'users/users_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get 'books/test_error' # TESTING. REMOVE FOR PRODUCTION

  resources :users do
    collection do

      get :login
      get :logout
      get :login_attempt
      post :login_attempt
   
      post :search

      get :display_subpage

      get :own_show

      get :new_follow
      get :unfollow

      get :edit_photo

      post :edit_about
      post :upload_photo
     
    end
  end

  resources :books do
    collection do

      get :get_book
      post :get_book

      get :get_book_live
      post :get_book_live

      get :select_book
      post :select_book

      get :submit_book
      post :submit_book
  
      get :delete_blurb
      post :delete_blurb

    end
  end

  get '/serve_image/:filename' => 'books#feed_image'
  get '/serve_user_photo/:filename' => 'users#feed_user_photo'

end

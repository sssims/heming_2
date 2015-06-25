Rails.application.routes.draw do

  root 'welcome#index'

  get 'home/index'
  post 'home/change_page'
  get 'home/change_page'

  get 'welcome/index'
  get 'welcome/sign_up'

  resources :users do
    collection do

      get :login
      get :logout

      get :login_attempt
      post :login_attempt
   
      post :search
      get :search # to remove, when I fix search refresh routing bug 

      get :display_subpage

      post :change_page
      get :change_page

      get :own_show

      get :follow
      post :follow

      get :edit_photo

      post :edit_about
      post :upload_photo
     
      post :delete_blurb

      post :delete_topten

      post :topten_reorder_up
      post :topten_reorder_down

      get :render_topten_modal

      get :get_books
      post :get_book

      get :select_book
      post :select_book

      get :submit_book
      post :submit_book

    end
  end

  get 'books/index'
 
  resources :books, :only => [:index] do
    collection do

      get :get_book
      post :get_book

      get :get_books
      post :get_books

      get :select_book
      post :select_book

      get :submit_book
      post :submit_book
  
      get :delete_blurb
      post :delete_blurb

    end
  end

  get  'users/follow_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get  'users/blurbs_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get  'users/users_show' # THIS IS FOR TESTING. REMOVE FOR PRODUCTION
  get 'books/test_error' # TESTING. REMOVE FOR PRODUCTION

  get '/serve_image/:filename' => 'books#feed_image'
  get '/serve_user_photo/:filename' => 'users#feed_user_photo'

end

# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|

    signed_in = session[:user_id]
    
    if signed_in
      current_user = User.find session[:user_id]
    end

    signup_url = url_for :controller => 'users', :action => 'new'
    login_url  = url_for :controller => 'users', :action => 'login'
    logout_url = url_for :controller => 'users', :action => 'logout'
    books_url  = url_for :controller => 'books', :action => 'index'

    # FOLLOW TESTING
    follow_url = url_for :controller => 'users', :action => 'follow_show'
    # --------------

    primary.item :key_7, 'Books' , :class => 'label', if: -> { signed_in }
    primary.item :key_8, 'From my people', if: -> { signed_in }
    primary.item :key_9, 'Post a book', books_url, if: -> { signed_in }

    primary.item :key_10, 'You', :class => 'label', if: -> { signed_in }
    primary.item :key_11, 'Books Posted', if: -> { signed_in }
    primary.item :key_12, 'Following', if: -> { signed_in }
    primary.item :key_13, 'Followers', if: -> { signed_in }

    # below is jank. Double 'if'. TO_FIX
    if signed_in 
      primary.item :key_14, current_user.fullname, :class => 'label', if: -> { signed_in }
    end

    primary.item :key_11, 'Books Posted', if: -> { signed_in }
    primary.item :key_12, 'Following', follow_url, if: -> { signed_in }
    primary.item :key_13, 'Followers', if: -> { signed_in }
    primary.item :key_15, 'About', if: -> { signed_in }

    primary.item :key_0, 'People', :class => 'label'
    primary.item :key_1, 'Featured'
    primary.item :key_2, 'Search...'

    primary.item :key_3, 'Utility', :class => 'label'
    primary.item :key_4, 'Log In', login_url, if: -> { !signed_in }
    primary.item :key_5, 'Sign Up', signup_url, if: -> { !signed_in }
    primary.item :key_6, 'Log Out', logout_url, if: -> { signed_in }

  end
end

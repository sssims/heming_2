class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_filter :check_logged_in

  def check_logged_in
    @logged_in = session[:user_id]
    @curr_username = 'guest'
    @curr_user_id  = 0
    if @logged_in
      curr_user = User.find(@logged_in)
      @curr_fullname = curr_user.fullname
      @curr_user_id  = curr_user.id
    end
   
  end

  protect_from_forgery with: :exception
  protected
  def authenticate_user
    if session[:user_id]
      @current_user = User.find session[:user_id]
      return true
    else
      # redirect_to(:controller => ... # force login
      return false
    end
  end
  def save_login_state
    if session[:user_id]
      return false
    else
      return true
    end
  end

  helper_method :authenticate_user
end

class WelcomeController < ApplicationController

  def index

    if @logged_in

      redirect_to :controller => 'home', :action => 'index'       

    end

    if !@error_message
      @error_message = ""
    end
    @user = User.new

  end

  def sign_up
  
    render :partial => '/users/new', :layout => false

  end

end

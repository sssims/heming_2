class UsersController < ApplicationController
  protect_from_forgery
 
  require 'open-uri'

  def new
    if !@error_message
      @errer_message = ""
    end
    @no_nav_bar = true
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    @user.cred = false
    @user.photo_link = '/serve_user_photo/default.jpeg'

    if @user.save
      session[:user_id] = @user.id
      redirect_to(:controller => 'home', :action => 'index')
      return
    else
      @error_message = "errors in form submission"
    end
    @no_nav_bar = true
    render "new" 
  end
  def user_params
    params.require(:user).permit(:username, :email, :password, :enc_pword, :fullname, :salt)
  end

  def show
    user = User.find(params[:id])
  
    @user_id    = user.id
    @user_photo = user.photo_link
    @user_about = user.about
    @user_name  = user.fullname.titleize

    @is_following = Relationship.exists?(follower_id: session[:user_id], followed_id: params[:id])
    @is_own_user = (params[:id].to_i == session[:user_id].to_i)
    
  end

  # HANDLE LOGIN / LOGOUT
  def login
    @no_nav_bar = true
  end
 
  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email], params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      redirect_to(:controller => 'home', :action => 'index')
    else
      @no_nav_bar = true
      @error_message = 'username and/or password incorrect.'
      render "login"
    end
  end

  def new_follow

     new_relat = Relationship.new(follower_id: session[:user_id], followed_id: params[:to_follow])
     new_relat.save

     redirect_to :controller => 'users', :action => 'show', :id => params[:to_follow]
  end 

  def unfollow
    to_destroy = Relationship.where(follower_id: session[:user_id], followed_id: params[:to_unfollow])

    Relationship.destroy(to_destroy.first.id)

    redirect_to :controller => 'users', :action => 'show', :id => params[:to_unfollow]
  end

  def logout
    session[:user_id] = nil
    redirect_to(:controller => 'home', :action => 'index')
  end
  
  def users_show
    @all_users = User.all
  end

  def follow_show
    @all_follows = Relationship.all
  end

  def blurbs_show
    @all_blurbs = Blurb.all
  end

  def display_subpage

    @is_own_user = (params[:view_user].to_i == session[:user_id].to_i)

    case params[:button_id]    
    when 'posts'
      @user_blurbs = []
      blurbs = Blurb.select("*, blurbs.id as blurb_id").joins(:user, :book).where(user_id: params[:view_user]).order(updated_at: :desc)
  
      blurbs.each do |blurb|
        one_blurb = []
        one_blurb.push(blurb.thumb_path)
        one_blurb.push(blurb.title.tr("-", " "))
        if !blurb.content?
          one_blurb.push("<blank>")
        else
          one_blurb.push(blurb.content)
        end
        one_blurb.push(blurb.fullname.titleize)
        one_blurb.push(blurb.blurb_id)
        one_blurb.push(blurb.created_at.strftime("%B %-d, %Y"))
        @user_blurbs.push(one_blurb)
      end
      render :partial => 'posts', :layout => false 
    when 'following'
      @user_following = Relationship.select("*").joins(:followed).where(follower: params[:view_user])
      render :partial => 'following', :layout => false 
    when 'followers'
      @user_followers = Relationship.select("*").joins(:follower).where(followed: params[:view_user])
      render :partial => 'followers', :layout => false 
    when 'top_ten'
      render :partial => 'top_ten', :layout => false 
    when 'about'
      @about_content = User.find(params[:view_user]).about
      @about_photo   = User.find(params[:view_user]).photo_link

      render :partial => 'about', :layout => false 
    when 'edit_profile'
      render 'edit_photo', :layout => false
    end
  end
 
  def edit_about
    new_about_content = params[:edit_about_content]
    
    User.update(session[:user_id], :about => new_about_content.first)

    redirect_to :controller => 'users', :action => 'show', :id => session[:user_id]
  end

  def search
    user_query = params[:search_people_content]

    @results = User.where("username LIKE ? OR fullname LIKE ?", "%#{user_query}%", "%#{user_query}%")

  end

  def edit_photo 

  end

  def feed_user_photo
    path = Rails.root.to_s << "/content/user_photos/#{params[:filename]}" << ".jpeg"

    send_file( path,
      :disposition => 'inline',
      :type => 'image/jpeg',
      :x_sendfile => true )

  end

  def upload_photo
    @about_photo = params[:uploadfile]
    if params[:uploadfile].content_type != 'image/jpeg'
      @upload_error = 'only jpegs may be submitted'
      render 'edit_photo'
      return
    end

    img_file_path = Rails.root.to_s << '/content/user_photos/' << session[:user_id].to_s << '_0.jpeg'
  
    open(img_file_path, 'wb') do |file|
      file << open(params[:uploadfile]).read
    end

    img = Magick::Image.read(img_file_path).first
    img = img.resize_to_fit(256,256)
    img.write(img_file_path)

    serve_photo_path = '/serve_user_photo/' << session[:user_id].to_s << '_0.jpeg'
    User.update(session[:user_id], :photo_link => serve_photo_path)
  
    redirect_to :action => 'show', :id => session[:user_id]
  end
 
  def delete_blurb

    Blurb.destroy(params[:blurb_id])
 
    render :nothing => true
  
  end

end

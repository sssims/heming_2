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
    @user.photo_link_full = '/serve_user_photo/default_full.jpeg'
    @user.photo_link_thumb = '/serve_user_photo/default_thumb.jpeg'

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
    @user_photo = user.photo_link_full
    @user_about = user.about
    @user_name  = user.fullname.titleize

    @is_following = Relationship.exists?(follower_id: session[:user_id], followed_id: params[:id])
    @is_own_user = (params[:id].to_i == session[:user_id].to_i)
    
  end

  def login


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

  def new_follow(this_user, view_user)

     new_relat = Relationship.new(follower_id: this_user, followed_id: view_user)

     new_relat.save

  end 

  def un_follow(this_user, view_user)

    to_destroy = Relationship.where(follower_id: this_user, followed_id: view_user)

    Relationship.destroy(to_destroy.first.id)

  end

  def follow

    this_user = session[:user_id]
    view_user = params[:view_user]

    if Relationship.exists?(follower_id: session[:user_id], followed_id: view_user)
      un_follow(this_user, view_user) 
      @is_following = false
    else
      new_follow(this_user, view_user) 
      @is_following = true
    end

    render :partial => 'follow_button', :layout => false

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

      @blurb_page = 0

      @blurb_array = get_blurbs(@blurb_page)
 
      render :partial => 'posts', :layout => false 

    when 'following'

      @user_following = Relationship.select("*").joins(:followed).where(follower: params[:view_user])
      render :partial => 'following', :layout => false 
    when 'followers'
      @user_followers = Relationship.select("*").joins(:follower).where(followed: params[:view_user])
      render :partial => 'followers', :layout => false 
    when 'top_ten'

      @user_topten = Topten.select("*, toptens.id as topten_id").joins(:user, :book).where(user_id: params[:view_user]).order(:order)

      render :partial => 'top_ten', :layout => false 

    when 'about'
      @about_content = User.find(params[:view_user]).about
      @about_photo   = User.find(params[:view_user]).photo_link_full

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

    if user_query.nil?
      @results = []
    else 
      @results = User.where("username LIKE ? OR fullname LIKE ?", "%#{user_query}%", "%#{user_query}%")
    end

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

    img_full_path = Rails.root.to_s << '/content/user_photos/' << session[:user_id].to_s << '_0_full.jpeg'

    img_thumb_path = Rails.root.to_s << '/content/user_photos/' << session[:user_id].to_s << '_0_thumb.jpeg'
  
    open(img_full_path, 'wb') do |file|
      file << open(params[:uploadfile]).read
    end

    open(img_thumb_path, 'wb') do |file|
      file << open(params[:uploadfile]).read
    end

    full_img = Magick::Image.read(img_full_path).first
    thumb_img = Magick::Image.read(img_thumb_path).first

    full_img = full_img.resize_to_fit(256, 414)
    full_img.write(img_full_path)

    thumb_img = thumb_img.resize_to_fit(150, 243)
    thumb_img.write(img_thumb_path)

    full_serve_path = '/serve_user_photo/' << session[:user_id].to_s << '_0_full.jpeg'
    User.update(session[:user_id], :photo_link_full => full_serve_path)

    thumb_serve_path = '/serve_user_photo/' << session[:user_id].to_s << '_0_thumb.jpeg'
    User.update(session[:user_id], :photo_link_thumb => thumb_serve_path)

    redirect_to :action => 'show', :id => session[:user_id]

  end
 
  def get_blurbs(page_number=0)

      blurb_array = []
      blurbs = Blurb.select("*, blurbs.id as blurb_id").joins(:user, :book).where(user_id: params[:view_user]).order(updated_at: :desc).offset(page_number * 10).limit(10)
  
      blurbs.each do |blurb|
        one_blurb = []
        one_blurb.push(blurb.thumb_path)
        one_blurb.push(blurb.title.tr("-", " "))
        one_blurb.push(blurb.content)
        one_blurb.push(blurb.fullname.titleize)
        one_blurb.push(blurb.user_id)
        one_blurb.push(blurb.created_at.strftime("%B %-d, %Y"))
        one_blurb.push(blurb.blurb_id)
        blurb_array.push(one_blurb)
      end
     
      return blurb_array

  end

  def render_topten_modal
 
    render :partial => 'post_topten_form', :layout => false

  end

  def get_books
    
    search = params[:topten_books_search_field]

    @books = GoogleBooks.search(search, {:count => 12}).to_a

    @books_content =[]

    @books.each do |book|

       if book.title.nil? or book.title == "" or book.isbn.nil? or book.isbn == "" or book.image_link.nil? or book.image_link == ""
         next
       end

       this_book = [book.isbn, book.title.tr(" ", "-"), book.image_link(:zoom => 1), book.image_link(:zoom => 4)]

       @books_content.push(this_book)

    end

    render :partial => 'post_topten_books', :layout => false

  end

  def select_book

    session[:topten_selected_img] = params[:topten_img]
    session[:topten_selected_thumb] = params[:topten_thumb]

    @topten_b_title = params[:topten_title]
    @topten_b_isbn =  params[:topten_isbn]
    
    render :partial => 'post_topten_blurb', :layout => false

  end

  def submit_book

    isbn = params[:topten_isbn]
    title = params[:topten_title]

    #if !Book.exists?(:title => title) and !Book.exists?(:isbn => isbn)
    if !Book.exists?(:isbn => isbn)
      new_book = Book.new 
      new_book.title = title
      new_book.isbn  = isbn

      full_name = isbn + '_00_full'
      full_path = Rails.root.to_s + '/content/covers/' + full_name + '.jpeg'

      thumb_name = isbn + '_00_thumb'
      thumb_path = Rails.root.to_s + '/content/covers/' + thumb_name + '.jpeg'

      begin
        img_from_url = open(session[:topten_selected_img])
        open(full_path, 'wb') do |file|      
          file << img_from_url.read
        end
      rescue OpenURI::HTTPError
        full_name = 'unavailable_full'
      end

      open(thumb_path, 'wb') do |file|      
        file << open(session[:topten_selected_thumb]).read
      end

      session.delete(:topten_selected_img)
      session.delete(:topten_selected_thumb)

      new_book.image_path = '/serve_image/' + full_name + '.jpeg' 
      new_book.thumb_path = '/serve_image/' + thumb_name + '.jpeg' 

      new_book.save
 
    end
 
    blurb_book = Book.find_by_isbn(isbn)

    #if blurb_book.nil?
    #  blurb_book = Book.find_by_title(title)
    #end

    #if blurb_book.nil?
    #  #ERROR. TODO: Make a subpage saying there's an error. OR => make it so books Always have a proper ISBN.
    #end

    new_topten = Topten.new
    new_topten.blurb= params[:topten_blurb_form_field]
    new_topten.user_id = session[:user_id]
    new_topten.book_id = blurb_book.id
    new_topten.order   = 9

    if new_topten.save
      #redirect_to(:controller => 'home', :action => 'index')
    else 
      # TODO: Change this to handle errors. Now, it redirects to home page as if there were no error.
      #redirect_to(:controller => 'home', :action => 'index')
    end

    redirect_to(:controller => 'users', :action => 'show', :id => session[:user_id])

  end

  def change_page

    @blurb_page = Integer(params[:blurb_page])

    @blurb_array = get_blurbs(@blurb_page)

    render :partial => 'posts', :layout => false

  end

  def delete_blurb

    Blurb.destroy(params[:blurb_id])
 
    render :nothing => true
  
  end

end

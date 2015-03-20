class BooksController < ApplicationController

  require 'open-uri'

  def index

    render :partial => 'index_partial', :layout => false

  end

  # if javascript is disabled on client browser navigate to new page.
  def get_book
    @count = 0
    book_title = params[:book_search_field]
    @books = GoogleBooks.search(book_title, {:count => 10})
    @books = @books.first(10)
  end 
  
  def get_book_live
    search = params[:book_search_field]


    @books = GoogleBooks.search(search, {:count => 5})

    i = 0;
    @titles = []
    @books.each do |book|
       @titles[i] = book.title.tr(" ", "-") 
       #@titles[i] = book.title.tr(",", "")
       i += 1
    end


   # Rails.cache.write('selected_books', books_hash)

    render :partial => 'book_results', :layout => false
  end

  def select_book

    session[:selected_img] = params[:img]
    session[:selected_thumb] = params[:thumb]

    # USING Hidden Params
     
    @b_title = params[:title]
    @b_isbn =  params[:isbn]

    render :partial => 'blurb_form', :layout => false
  end

  def feed_image
    path = Rails.root.to_s + "/content/covers/#{params[:filename]}" + '.jpeg'

    send_file( path,
      :disposition => 'inline',
      :type => 'image/jpeg',
      :x_sendfile => true )
    
  end

  def submit_book
    if !Book.exists?(:title => params[:title])
      new_book = Book.new 
      new_book.title = params[:title]
      new_book.isbn  = params[:isbn]

      full_name = params[:isbn] + '_00_full'
      full_path = Rails.root.to_s + '/content/covers/' + full_name + '.jpeg'

      thumb_name = params[:isbn] + '_00_thumb'
      thumb_path = Rails.root.to_s + '/content/covers/' + thumb_name + '.jpeg'

      begin
        img_from_url = open(session[:selected_img])
        open(full_path, 'wb') do |file|      
          file << img_from_url.read
        end
      rescue OpenURI::HTTPError
        full_name = 'unavailable_full'
      end

      open(thumb_path, 'wb') do |file|      
        file << open(session[:selected_thumb]).read
      end

      session.delete(:selected_img)
      session.delete(:selected_thumb)

      new_book.image_path = '/serve_image/' + full_name + '.jpeg' 
      new_book.thumb_path = '/serve_image/' + thumb_name + '.jpeg' 

      new_book.save
    end
  
    blurb_book = Book.find_by_title(params[:title])
 
    new_blurb = Blurb.new
    new_blurb.content = params[:blurb_form_field]
    new_blurb.user_id = session[:user_id]
    new_blurb.book_id = blurb_book.id
    new_blurb.save

    redirect_to(:controller => 'home', :action => 'index')
  end

  def delete_blurb


  end 

end

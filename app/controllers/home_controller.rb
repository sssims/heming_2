class HomeController < ApplicationController

  def get_blurbs(page_number=0)

    blurb_array = []

    blurbs = nil

    if @page_name == 'index' 
      blurbs = Blurb.select("*, blurbs.id AS blurb_id").joins(:user, :book).order(created_at: :desc).offset(page_number * 10).limit(10)
    elsif @page_name == 'featured'
      blurbs = Blurb.select("*, blurbs.id AS blurb_id").joins(:user, :book).where("users.cred = ?", 't').order(created_at: :desc).offset(page_number * 10).limit(10)
    elsif @page_name == 'following'
      blurbs = Blurb.select("*, blurbs.id AS blurb_id").joins('INNER JOIN users ON users.id=blurbs.user_id INNER JOIN books ON books.id=blurbs.book_id INNER JOIN relationships ON users.id=followed_id').where("follower_id = ?", session[:user_id]).order(created_at: :desc).offset(page_number * 10).limit(10)
    else
      #error
    end

    blurbs.each do |blurb|

      blurb_content = []

      # get content to be displayed from DOM
      # using an array is error prone (must keep track of index of each content)
      # possible improvement -> Put blurb content in an object instead of array 

      blurb_content.push(blurb.thumb_path)
      blurb_content.push(blurb.title.tr("-", " "))
      blurb_content.push(blurb.content)
      blurb_content.push(blurb.fullname.titleize)
      blurb_content.push(blurb.user_id)
      blurb_content.push(blurb.created_at.strftime("%B %-d, %Y"))
      blurb_content.push(blurb.blurb_id)

      blurb_array.push(blurb_content)

    end

    return blurb_array

  end

  def index

    @page_name = "following"

    @blurb_page = 0

    @blurb_array = get_blurbs(@blurb_page)

  end

  def featured

    @page_name = "featured"

    @blurb_page = 0
    
    @blurb_array = get_blurbs(@blurb_page)

  end

  def change_page

    @page_name = params[:page_name]
   
    @blurb_page = Integer(params[:blurb_page])
 
    @blurb_array = get_blurbs(@blurb_page)

    render :partial => 'index_feed', :layout => false

  end

end

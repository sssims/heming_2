class HomeController < ApplicationController

  def get_blurbs(page_number=0)

    blurb_array = []

    # the below is for selecting by 'credited' users
    #blurbs = Blurb.select("*").joins(:user, :book).where("users.cred = ?", true).order(updated_at: :desc)

    blurbs = Blurb.select("*").joins(:user, :book).order(updated_at: :desc).offset(page_number * 10).limit(10)

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

      blurb_array.push(blurb_content)

    end

    return blurb_array

  end

  def index

    @blurb_page = 0

    @blurb_array = get_blurbs(@blurb_page)

  end

  def change_page
   
    @blurb_page = Integer(params[:blurb_page])
 
    @blurb_array = get_blurbs(@blurb_page)

    render :partial => 'layouts/blurb_feed', :layout => false

  end

end

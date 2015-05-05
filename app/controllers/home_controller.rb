class HomeController < ApplicationController

  def get_blurbs(page_number=0)

    # How to order these

    blurb_array = []

    # the below is for selecting by 'credited' users
    #blurbs = Blurb.select("*").joins(:user, :book).where("users.cred = ?", true).order(updated_at: :desc)

    blurbs = Blurb.select("*").joins(:user, :book).order(updated_at: :desc).offset(page_number * 10).limit(10)

    temp_count = 0;

    blurbs.each do |blurb|
      blurb_content = []
      blurb_content.push(blurb.thumb_path)

      if blurb.title.length > 28
        trunc_title = blurb.title[0..28] + '...'

        blurb_content.push(trunc_title.tr("-", " "))
      else
        blurb_content.push(blurb.title.tr("-", " "))
      end

      if !blurb.content?
        # for designing views. CHANGE FOR DEPLOYMENT
        blurb_content.push("<blank blurb>")
      else
        blurb_content.push(blurb.content)
      end
      # REMOVE TITLEIZE FOR DEPLOYMENT
      blurb_content.push(blurb.fullname.titleize)
      blurb_content.push(blurb.user_id)
      blurb_content.push(blurb.created_at.strftime("%B %-d, %Y"))
      blurb_array.push(blurb_content)
    end

    return blurb_array
  end

  def index

=begin
    Book.select("*").each do |book|
      if book.image_path == nil or book.image_path == '/serve_image/unavailable_full.jpeg'
        thumb_path = Rails.root.to_s + '/content/covers/' + book.isbn.to_s + '_00_thumb.jpeg'
     
        cover = Magick::Image.read(thumb_path).first
        cover = cover.resize_to_fit(210, 420)
        cover.write(thumb_path)
      else
        large_path = Rails.root.to_s + '/content/covers/' + book.isbn.to_s + '_00_full.jpeg'
        new_path = Rails.root.to_s + '/content/covers/' + book.isbn.to_s + '_00_thumb.jpeg'

        cover = Magick::Image.read(large_path).first
        cover = cover.resize_to_fit(210, 420)
        cover.write(new_path)
      end
    end
   
    uncomment ro resize all images
=end

    @blurb_array = get_blurbs

  end

  def change_page
   
    blurb_page = Integer(params[:blurb_page])
 
    @blurb_array = get_blurbs(blurb_page)

    render :partial => 'blurb_feed', :layout => false

  end

end

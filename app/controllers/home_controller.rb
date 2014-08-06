class HomeController < ApplicationController

  def get_blurbs
    blurb_array = []

    # the below is for selecting by 'credited' users
    #blurbs = Blurb.select("*").joins(:user, :book).where("users.cred = ?", true)

    blurbs = Blurb.select("*").joins(:user, :book)

    blurbs.each do |blurb|
      blurb_content = []
      blurb_content.push(blurb.thumb_path)

      if blurb.title.length > 28
        title = blurb.title[0..28] + '...'

        blurb_content.push(title.tr("-", " "))
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
end

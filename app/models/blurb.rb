class Blurb < ActiveRecord::Base

  belongs_to :user 
  belongs_to :book

  validates :content, :length => { :in => 0..500 }

end

class Book < ActiveRecord::Base
  validates :title, :presence => true, :length => { :in => 1..64 }

  belongs_to :blurb
end

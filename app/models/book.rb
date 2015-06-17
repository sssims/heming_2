class Book < ActiveRecord::Base

  validates :title, :presence => true, :length => { :in => 1..128 }

  has_many :blurbs
  has_many :toptens

end

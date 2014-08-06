class User < ActiveRecord::Base
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  #has_many :followed_users, through: :relationships, source: :followed
  #has_many :following_users, through: :relationships, source: :follower

  has_many :blurbs

  attr_accessor :password

  before_save :encrypt_password  
  after_save  :clear_password

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :fullname, :presence => true, :length => { :in => 3..31 }
  validates :email, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true #password_confirmation attr

  validates_length_of :password, :in => 2..20, :on => :create
  validates_uniqueness_of :username, :case_sensitive => false

  def encrypt_password
    if password.present?
       self.salt = BCrypt::Engine.generate_salt
       self.enc_pword = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def self.authenticate(username_or_email="", login_password="")
    if EMAIL_REGEX.match(username_or_email)
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end
  
    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end

  def match_password(login_password="")
    enc_pword == BCrypt::Engine.hash_secret(login_password, salt)
  end
end

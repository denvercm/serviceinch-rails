require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  cattr_reader :per_page
  @@per_page = 10


  has_one :user_access

  validates :login, :presence => true,
                    :length => {:within => 3..40},
                    :uniqueness => true,
                    :format => {:with => Authentication.login_regex, :message => Authentication.bad_login_message}

  validates :name, :length => {:maximum => 100},
                   :format => {:with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true}

  validates :email, :presence => true,
            :length => {:within => 6..100},
            :uniqueness => true,
            :format => {:with => Authentication.email_regex, :message => Authentication.bad_email_message}


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = where(:login => login.downcase).includes(:user_access).first # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    self[:login] = value ? value.downcase : nil
  end

  def email=(value)
    self[:email] = value ? value.downcase : nil
  end

end

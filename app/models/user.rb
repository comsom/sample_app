require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  # email の構文(Wikipedia)： / <ローカル部> @ <ドメイン> /x
  email_regex = / \A [\w+\-.]+ @ [a-z\d\-.]+ \. [a-z]+ \z /xi

  validates :name, :presence => true,
                   :length   => { :maximum => 25 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    # return nil
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    def encrypt(string)
      Digest::SHA256.hexdigest("#{salt}--#{string}")
    end
    def make_salt
      Digest::SHA256.hexdigest("#{Time.now.utc}--#{password}")
    end
end


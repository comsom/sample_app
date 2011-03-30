class User < ActiveRecord::Base
  attr_accessible :name, :email

  # email の構文(Wikipedia)： / ローカル部 @ ドメイン /x
  email_regex = / \A [\w+\-.]+ @ [a-z\d\-.]+ \. [a-z]+ \z /xi

  validates :name,  :presence => true,
                    :length   => { :maximum => 25 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

end

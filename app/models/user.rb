class User < ActiveRecord::Base
  #uses bcrypt to hash and salt password
  has_secure_password
end

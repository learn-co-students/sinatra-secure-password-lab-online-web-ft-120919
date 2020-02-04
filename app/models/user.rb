class User < ActiveRecord::Base
    has_secure_password
end


# rake db:create_migration NAME=create_users

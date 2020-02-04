class CreateUsers < ActiveRecord::Migration[5.1]

  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
    end
  end

end

# rake db:create_migration NAME=create_users
# rake db:migrate SINATRA_ENV=test


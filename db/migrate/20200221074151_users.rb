class Users < ActiveRecord::Migration[5.1]
  def change
    create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
  end
  end
end

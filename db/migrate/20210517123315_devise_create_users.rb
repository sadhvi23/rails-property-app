class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    # Users table to know user details
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string :name
      t.string :role, limit: 64
      t.string :status, limit: 64, default: 'ACTIVE'

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end

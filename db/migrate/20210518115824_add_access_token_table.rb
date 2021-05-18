class AddAccessTokenTable < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tokens do |t|
      t.references :users, :user, foreign_key: true
      t.string :token, null: false
      t.boolean :active
      t.datetime :expires_at
      t.timestamps
    end
  end
end

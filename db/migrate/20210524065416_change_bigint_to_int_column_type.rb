class ChangeBigintToIntColumnType < ActiveRecord::Migration[6.1]
  def change
    change_column :properties, :id, :integer
    change_column :properties, :owner_id, :integer

    change_column :users, :id, :integer
    change_column :users, :role_id, :integer

    change_column :roles, :id, :integer

    change_column :user_tokens, :id, :integer
    change_column :user_tokens, :user_id, :integer

    change_column :user_roles, :user_id, :integer
    change_column :user_roles, :role_id, :integer
    change_column :user_roles, :id, :integer
  end
end

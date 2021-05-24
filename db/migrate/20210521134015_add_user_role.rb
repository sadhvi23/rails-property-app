class AddUserRole < ActiveRecord::Migration[6.1]
  def change
    # User Roles table
    create_table :user_roles, &:timestamps
    # Add User role id to users table
    add_reference :user_roles, :user, foreign_key: { to_table: :users }
    add_reference :user_roles, :role, foreign_key: { to_table: :roles }
  end
end

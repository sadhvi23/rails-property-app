class AddUserRolesTable < ActiveRecord::Migration[6.1]
  def change
    # User Roles table
    create_table :roles do |t|
      t.string :name, default: ''
      t.timestamps
    end
    # Add User role id to users table
    add_reference :users, :role, foreign_key: { to_table: :roles }
    # Rename Columns
    remove_column :users, :status, :string
    add_column :users, :is_active, :boolean
    # Remove column
    remove_column :users, :user_id, :bigint
    remove_column :users, :role, :string
  end
end

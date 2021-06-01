class AddPasswordFieldsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :salt, :text
  end
end

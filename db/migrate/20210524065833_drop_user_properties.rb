class DropUserProperties < ActiveRecord::Migration[6.1]
  def change
    drop_table :user_properties
  end
end

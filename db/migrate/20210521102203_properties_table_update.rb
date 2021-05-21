class PropertiesTableUpdate < ActiveRecord::Migration[6.1]
  def change
    # Remove column
    remove_column :properties, :property_id, :bigint
    remove_column :properties, :updated_by_id, :bigint
    # Rename Columns
    remove_column :properties, :approval_status, :boolean
    add_column :properties, :is_approved, :boolean, default: false
    remove_column :properties, :availability_status, :boolean
    add_column :properties, :is_available, :boolean, default: false
    remove_column :properties, :active, :boolean
    add_column :properties, :is_active, :boolean, default: false
    rename_column :properties, :created_by_id, :owner_id
  end
end

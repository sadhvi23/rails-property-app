class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    # Properties table to know property details
    create_table :properties do |t|
      t.string :name
      t.string :approval_status, default: 'ON_HOLD', limit: 64
      t.boolean :active, default: 1
      t.string :availability_status, default: 'ON_HOLD', limit: 64
      t.timestamps
    end

    # Relational table between owner and properties once user bought property entry will happen for that user and prop
    create_table :user_properties do |t|
      add_reference :users, :user, foreign_key: true
      add_reference :properties, :property, foreign_key: true
      t.timestamps
    end
    add_reference :properties, :created_by, foreign_key: { to_table: :users }
    add_reference :properties, :updated_by, foreign_key: { to_table: :users }
  end
end

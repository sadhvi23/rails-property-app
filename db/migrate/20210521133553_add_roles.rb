class AddRoles < ActiveRecord::Migration[6.1]
  def change
    Role.create(name: 'super_admin')
    Role.create(name: 'user')
    Role.create(name: 'admin')
  end
end

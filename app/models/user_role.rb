class UserRole < ApplicationRecord

  # Associations
  belongs_to :user
  belongs_to :role
end

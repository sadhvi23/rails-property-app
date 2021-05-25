class Role < ApplicationRecord

  # Associations
  has_one :user

  # Validation
  validates :name, presence: true, inclusion: { in: %w[super_admin admin user], message: '%{value} is not a valid role' }
end

class Role < ApplicationRecord

  # Associations
  has_one :user
  has_many :user_roles

  # Validation
  validates :name, presence: true, inclusion: { in: %w[super_admin admin user], message: '%{value} is not a valid role' }
end

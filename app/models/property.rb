class Property < ApplicationRecord
  # Associations
  belongs_to :user, foreign_key: 'created_by_id'
  belongs_to :user, foreign_key: 'updated_by_id'
  has_many :user_properties

  # Callbacks
  before_update :check_approval_status, if: :approval_status_changed?
  before_update :check_admin_can_update

  # Check only owner can update the approval status
  def check_approval_status
    raise "User can't approve/reject properties" if user.role == 'USER'
  end

  # Validate that user and admin cant update other property attributes
  def check_admin_can_update
    if (user.role == 'USER' || user.role == 'ADMIN') && (availability_status_changed? || name_changed? || active_changed?)
      raise "Admin or User can't update other property attributes"
    end
  end
end

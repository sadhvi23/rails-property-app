class Property < ApplicationRecord

  # Associations
  belongs_to :user, foreign_key: 'owner_id', optional: true

  # Callbacks
  before_update :check_approval_status, if: :is_approved_changed?
  before_update :check_admin_can_update

  # Check only owner can update the approval status
  def check_approval_status
    raise "User can't approve/reject properties" if user&.role&.name == 'user'
  end

  # Validate that user and admin cant update other property attributes
  def check_admin_can_update
    if (user&.role&.name == 'user' || user&.role&.name == 'admin') && (is_available_changed? || name_changed? || is_active_changed?)
      raise "Admin or User can't update other property attributes"
    end
  end
end

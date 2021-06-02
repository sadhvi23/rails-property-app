class Property < ApplicationRecord

  # Associations
  belongs_to :user, foreign_key: 'owner_id', optional: true

  # Validation
  validates :owner_id, presence: true
  validates :name, presence: true

  # Callbacks
  before_update :check_approval_status, if: :is_approved_changed?

  # Check only owner can update the approval status
  def check_approval_status
    raise "User can't approve/reject properties" if @current_user&.role&.name == 'user'
  end
end

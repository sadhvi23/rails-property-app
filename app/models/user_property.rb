class UserProperty < ApplicationRecord

  # Associations
  belongs_to :user
  belongs_to :property
end

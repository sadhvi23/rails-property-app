class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_secure_password

  attr_accessor :password_digest, :perform_action

  # Associations
  has_many :properties
  has_many :user_properties
  has_many :user_tokens
  belongs_to :role

  # Validation
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  # Store access token in DB
  def store_user_tokens(token, exp)
    user_tokens.create(token: token, expires_at: exp, active: 1)
  end

  # Add role id in user signup
  def update_user_role
    role_id = Role.where(name: 'super_admin').first&.id
    self.role_id = role_id
  end
end

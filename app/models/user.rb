class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_secure_password

  attr_accessor :password_digest, :perform_action

  # Associations
  has_many :properties, dependent: :destroy, foreign_key: :owner_id
  has_many :user_tokens, dependent: :destroy
  belongs_to :role

  # Validation
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  # Store access token in DB
  def store_user_tokens(token, exp)
    user_tokens.create(token: token, expires_at: exp, active: 1)
  end

  # Add role id in user signup/create
  def update_user_role(role)
    role_id = Role.where(name: role).first&.id
    self.role_id = role_id
    self.is_active = true
  end
end

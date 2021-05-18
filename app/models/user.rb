class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_secure_password

  attr_accessor :password_digest

  # Associations
  has_many :properties
  has_many :user_properties
  has_many :user_tokens

  # Validations
  validates :role, presence: true, inclusion: { in: %w[SUPER_ADMIN ADMIN USER], message: '%{value} is not a valid role' }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  # Store access token in DB
  def store_user_tokens(token, exp)
    user_tokens.create(token: token, expires_at: exp, active: 1)
  end
end

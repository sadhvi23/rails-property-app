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
  validates :name, format: { with: /\A[a-zA-z ]+\z/i, message: 'Name should include only letters' }

  before_save :encrypt_password

  # Add role id in user signup/create
  def update_user_role(role)
    role_id = Role.where(name: role).first&.id
    self.role_id = role_id
    self.is_active = true
  end

  # Generate Token
  def generate_token
    token = JsonWebToken.encode(user_id: id)
    time = (Time.now + 24.hours.to_i).strftime('%m-%d-%Y %H:%M')
    store_user_tokens(token, time)
    token
  end

  # Check authentication
  def authenticate(password)
    new_password = BCrypt::Engine.hash_secret(password, salt)
    encrypted_password == new_password
  end

  private

  # Store access token in DB
  def store_user_tokens(token, exp)
    user_tokens.create(token: token, expires_at: exp, active: 1)
  end


  # Store unique key and password
  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end
end

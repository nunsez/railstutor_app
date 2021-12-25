class LoginForm
  include ActiveModel::SecurePassword
  include ActiveModel::Validations

  has_secure_password validations: false

  validates :email, presence: true
  validates :password, presence: true

  validate :user_exist, :password_match

  attr_accessor :email, :password

  def initialize(options = {})
    @email = options[:email]
    @password = options[:password]
  end

  def user_exist
    return if email.blank?

    errors.add(:email, 'user does not exist') unless user
  end

  def password_match
    return if errors.include?(:email) || password.blank?

    errors.add(:password, "can't sign in") unless user&.valid_password?(password)
  end

  def user
    @user ||= User.find_by(email: email)
  end
end

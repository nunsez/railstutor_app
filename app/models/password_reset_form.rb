class PasswordResetForm
  include ActiveModel::Validations

  validates :email, presence: true

  validate :user_exist

  attr_accessor :email

  def initialize(options = {})
    @email = options[:email]
  end

  def user_exist
    return if email.blank?

    errors.add(:email, 'user does not exist') unless user
  end

  def user
    @user ||= User.find_by email: email
  end
end

class User < ApplicationRecord
  has_secure_password

  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    # format: { with: URI::MailTo::EMAIL_REGEXP }, # bad validation: 'user@invalid' marks as valid
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  def valid_password?(password)
    authenticate(password) if password_digest.present?
  end

  def guest? = false

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end

  private

  def downcase_email
    email.downcase!
  end
end

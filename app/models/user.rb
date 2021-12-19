class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  private

  def downcase_email
    self.email = email.downcase
  end
end

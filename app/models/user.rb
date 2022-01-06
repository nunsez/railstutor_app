class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: :follower_id,
                                  dependent: :destroy
  has_many :passive_relationships,  class_name: 'Relationship',
                                    foreign_key: :followed_id,
                                    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships

  scope :active, -> { where(activated: true) }

  before_create :create_activation_digest
  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    # format: { with: URI::MailTo::EMAIL_REGEXP }, # bad validation: 'user@invalid' marks as valid
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true

  paginates_per 10

  def valid_password?(password)
    authenticate(password) if password_digest.present?
  end

  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    BCrypt::Password.new(digest).is_password?(token)
  rescue BCrypt::Errors::InvalidHash
    false
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Micropost.where("user_id IN (#{ids}) OR user_id = :user_id", user_id: id)
  end

  def follow(target_user)
    active_relationships.create followed_id: target_user.id
  end

  def unfollow(target_user)
    active_relationships.find_by(followed_id: target_user.id).destroy
  end

  def following?(target_user)
    following.include? target_user
  end

  def guest? = false

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = self.class.new_token
    self.activation_digest = self.class.digest(activation_token)
  end
end

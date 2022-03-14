class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum role: {
    user: 0,
    admin: 1
  }, _prefix: true

  VALID_EMAIL_REGEX = Settings.regex.email

  attr_accessor :activated_token
  before_save :downcase_email
  before_create :create_activated_digest, :create_default_avatar

  validates :name, presence: true,
            length: {maximum: Settings.digits.name_max_length}
  validates :email, presence: true,
            length: {maximum: Settings.digits.email_max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :password, presence: true,
            length: {minimum: Settings.digits.password_min_length,
                     maximum: Settings.digits.password_max_length},
            allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def send_activated_email
    UserMailer.account_activation(self).deliver_now
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")

    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_column :activated, true
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activated_digest
    self.activated_token = User.new_token
    self.activated_digest = User.digest activated_token
  end

  def create_default_avatar
    self.avatar = Settings.avatar.default_avatar
  end
end

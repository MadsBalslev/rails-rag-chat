class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :collections
  has_many :documents, through: :collections

  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
